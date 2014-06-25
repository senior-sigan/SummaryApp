class RecordsImporter
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file

  attr_reader :event
  attr_reader :sheet

  validates :file, presence: true
  validates :event, presence: true
  validate :check_spreadsheet
  validate :records_validation

  def initialize(event)
    @event = event
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

  def persist!
    Record.transaction do
      records.each(&:save!)
    end
  rescue
    records_validation
  end

  def records
    @records ||= load_records
  end

  def sheet
    @sheet ||= Spreadsheet.new(@file)
  end

  def load_records
    sheet.records.map do |record|
      event.records.build record
    end
  end

  def check_spreadsheet
    return unless errors.blank?

    sheet.errors.each { |error| errors.add :base, error } unless sheet.valid?
  end

  def records_validation
    return unless errors.blank?

    unless records.map(&:valid?).all?
      records.each_with_index do |record, index|
        record.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message} #{record.email}"
        end
      end
    end
  end
end