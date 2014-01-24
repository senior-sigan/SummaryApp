class RegistrationImport
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file
  attr_accessor :event
  attr_accessor :fields

  validates :file, presence: true, spreadsheet: true
  validates :fields, presence: true
  validates :event, presence: true
  validate :participants_must_be_valid

  def initialize(params={})
    params.each do |attr, value|
      self.public_send "#{attr}=", value
    end if params
  end

  def persist?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

  #load imported data
  #validate each Participation row 
  #on invalid push error and return false
  #else return true
  def persist!
    @fields ||= []
    imported_users.each(&:save)
  end

  def participants_must_be_valid
    unless imported_users.map(&:valid?).all?
      imported_users.each_with_index do |user, index|
        user.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
    end
  end

  def imported_users
    @imported_users ||= load_users
  end

  def load_users
    spreadsheet = open_spreadsheet
    
    header = spreadsheet.row(1).map{|i| i.mb_chars.downcase.to_s unless i.nil? || i.empty?} #russian downcase
    @fields = JSON.parse(fields).map{|i| i.mb_chars.downcase.to_s unless i.nil? }

    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      next if row['email'].nil?
      participant = @event.participants.find_or_initialize_by(email: row["email"].downcase)
      if participant.new_record?
        participant.name = row["name"]
        participant.surname = row["surname"]
      end
      row.each do |key,value|
        next if default?(key)
        next if empty?(value)
        next if ignored?(key)
        participant[key] ||= ''
        participant[key] += "#{value}\n" unless participant[key].include?(value)
      end
      participant
    end.compact
  end

  def empty?(value)
    value.nil? || value.eql?("")
  end
  
  def default?(key)
    %w(email name surname).include?(key) || key.nil? || key.eql?("")
  end
  
  def ignored?(key)
    !fields.include?(key)
  end
  
  def open_spreadsheet
    Roo::CSV.new(file.path)
  end
end