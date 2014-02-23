class RegistrationImport
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file
  attr_accessor :event
  attr_accessor :black_list
  attr_accessor :attributes_map
  attr_accessor :build_new

  validates :file, presence: true
  validates :event, presence: true
  validate :check_spreadsheet

  def initialize(params={})
    @build_new = true

    params.each do |attr, value|
      self.public_send "#{attr}=", value
    end if params

    puts "BUILD NEW #{@build_new == true}"
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
    puts "participants #{participants.length}"
    participants.each(&:save)
  end

  def participants
    @participants ||= load_participants.compact
  end

  private

  def participants_validation
    return unless errors.blank?

    unless participants.map(&:valid?).all?
      participants.each_with_index do |user, index|
        user.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
    end
  end

  def check_spreadsheet
    return unless errors.blank?

    sheet = SpreadsheetParser.new file, black_list, attributes_map
    unless sheet.valid?
      sheet.errors.each do |error|
        errors.add :base, error
      end
    end

    participants_validation
  end

  def load_participants
    spreadsheet = SpreadsheetParser.new file, black_list, attributes_map
    participants_attributes = spreadsheet.parse

    participants_attributes.map do |participant_attributes|
      participant = event.participants.find_or_initialize_by(email: participant_attributes[:email])

      next if (build_new == false) && participant.new_record?

      participant_attributes.each do |key, value|
        participant[key] = value
      end

      participant
    end
  end
end