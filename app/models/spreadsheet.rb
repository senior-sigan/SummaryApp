require 'csv'

class Spreadsheet
  RECORD_KEYS = [:email, :name, :surname]

  attr_reader :errors

  def initialize(file)
    @errors = []
    @file = file
    open_spreadsheet
    parse_header
  end

  def records
    @records ||= @sheet[1..-1].map.with_index do |row, index|
      data = Hash[[@header, row].transpose].delete_if do |key, value|
        key.blank? || value.blank?
      end
      record = {}
      record[:email], record[:name], record[:surname] = data[:email], data[:name], data[:surname]
      record[:meta] = data.select { |key, _| !RECORD_KEYS.include? key }

      record
    end
  end

  def valid?
    validate
    errors.empty?
  end

  private

  def open_spreadsheet
    @sheet ||= CSV.open(@file.path, 'r').readlines
  end

  def parse_header
    @header ||= open_spreadsheet.first.map do |i|
      next if i.blank?

      i.gsub('.', ',').mb_chars.downcase.to_sym #russian downcase
    end
  end

  def validate
    index = 1

    @sheet.each do |row|
      if @header.length != row.length
        add_error("bad csv: header and row length does not match: #{index} line")
        next
      end
      index += 1
    end
  end

  def add_error(error)
    @errors << error
  end
end