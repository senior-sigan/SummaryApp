class ParticipationImport
  include ActiveModel::Model
  attr_accessor :file
  attr_reader :header
  attr_reader :new_users

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
    @new_users = 0
  end

  def open
  	if (@spreadsheet ||= open_spreadsheet)
      @header ||= @spreadsheet.row(1)
      return true
    else
      errors.add :base, "Undefined type of file"
      return false
    end
  end
  
  #load imported data
  #validate each Participation row 
  #on invalid push error and return false
  #else return true
  def save
    if file.nil?
      errors.add :base, "File can't be blank"
      return false
    end
    if imported_users.map(&:valid?).all?
      imported_users.each do |u|
        if u.new_record? 
          if u.save
            @new_users += 1
          else
            errors.add :base, u.errors.full_messages
            return false
          end
        else
          u.save
        end  
      end
      imported_users
    else
      imported_users.each_with_index do |user, index|
        user.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end      
      false
    end
  end

  def associate_columns_to_fields(params)

  end

  def imported_users
    @imported_users ||= load_users.uniq!(&:email)
  end

  def load_users
  	spreadsheet = open_spreadsheet
  	header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      begin
        user = User.find_by(email: row["email"].downcase)  
      rescue Exception => e
        user = User.new  
      end
      if user.new_record? 
        user.attributes = row.to_hash 
      end
      user
    end  
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