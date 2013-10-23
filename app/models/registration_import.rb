class RegistrationImport
  include ActiveModel::Model
  attr_accessor :file
  attr_reader :header
  attr_accessor :event
  attr_accessor :fields

  def open
  	if (@spreadsheet ||= open_spreadsheet)
      @header ||= @spreadsheet.row(1)
      return true
    else
      errors.add :base, "Undefined type of file"
      return false
    end
  end

  def valid?
    if file.nil?
      false
    else
      true
    end
  end

  #load imported data
  #validate each Participation row 
  #on invalid push error and return false
  #else return true
  def save
    @fields ||= []
    
    if file.nil?
      errors.add :base, "File can't be blank"
      return false
    end
    if imported_users.map(&:valid?).all?
      imported_users.uniq!(&:email)
      imported_users.each do |u|
        unless u.save
          errors.add :base, u.errors.full_messages
          return false
        end
      end
      true
    else
      imported_users.each_with_index do |user, index|
        participant.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end      
      false
    end
  end

  def associate_columns_to_fields(params)

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
    end  
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
    unless file.nil?
      case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      when ".ods" then Roo::Openoffice.new(file.path, nil, :ignore)
      else raise "Hell"
      end
    else
      errors.add :base, "File can't be blank"
      raise "Hell" 
    end
  end
end