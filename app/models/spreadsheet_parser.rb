require 'csv'

class SpreadsheetParser
  attr_reader :file
  attr_reader :attributes_map
  attr_reader :users
  attr_reader :black_list

  def initialize(file, black_list = [], attributes_map = {})
    @file = file
    @attributes_map = attributes_map
    @black_list = black_list
    @users = []
  end

  def parse
    open_spreadsheet
    parse_header
    apply_attributes_map_to_header

    @spreadsheet.each do |row|
      raise 'bad csv: header and row length does not match' if @header.length != row.length

      user = Hash[[@header, row].transpose].delete_if do |key, value|
        key.blank? || value.blank? || ignored?(key)
      end
      @users.push user
    end

    users
  end

  def ignored?(key)
    black_list.include?(key)
  end

  def open_spreadsheet
    file.rewind
    @spreadsheet ||= CSV.new(file)
  end

  def parse_header
    @header ||= open_spreadsheet.readline.map do |i|
      i.mb_chars.downcase.to_s unless i.blank? #russian downcase
    end
  end

  def apply_attributes_map_to_header
    unless attributes_map.empty?
      parse_header.map! do |attr|
        new_attr = attributes_map[attr]
        (new_attr ? new_attr : attr).to_sym
      end
    end
  end
end