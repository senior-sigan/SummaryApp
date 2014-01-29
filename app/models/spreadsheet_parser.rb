require 'csv'

class SpreadsheetParser
  attr_reader :file
  attr_reader :attributes_map
  attr_reader :users
  attr_reader :black_list

  def initialize(file, black_list = [], attributes_map = {})
    @file = file
    @attributes_map = attributes_map || {}
    @black_list = black_list || []
    @users = []
  end

  def parse
    open_spreadsheet
    parse_header
    normalize_attr_names
    apply_attributes_map_to_header

    @users = @spreadsheet.map.with_index do |row, index|
      raise "bad csv: header and row length does not match: #{index} line" if @header.length != row.length

      user = Hash[[@header, row].transpose].delete_if do |key, value|
        key.blank? || value.blank? || ignored?(key)
      end
    end

    users
  end

  def ignored?(key)
    black_list.include?(key)
  end

  def open_spreadsheet
    @spreadsheet ||= CSV.open(file.path, 'r')
  end

  def parse_header
    @header ||= open_spreadsheet.readline.map do |i|
      next if i.blank?

      i.mb_chars.downcase.to_sym #russian downcase
    end
  end

  def normalize_attr_names
    @black_list.map!{ |i| i.mb_chars.downcase.to_s unless i.blank? }.compact!
    norm_attr_map = {}
    @attributes_map.each do |key, value|
      next if key.blank? || value.blank?

      k = key.mb_chars.downcase.to_sym
      v = value.mb_chars.downcase.to_sym
      norm_attr_map[k] = v
    end
    @attributes_map = norm_attr_map
  end

  def apply_attributes_map_to_header
    unless attributes_map.empty?
      parse_header.map! do |attr|
        new_attr = attributes_map[attr]
        new_attr ? new_attr : attr
      end
    end
  end
end