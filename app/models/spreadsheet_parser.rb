require 'csv'

class SpreadsheetParser
  attr_reader :file
  attr_reader :attributes_map
  attr_reader :users
  attr_reader :black_list
  attr_reader :errors

  def initialize(file, black_list = [], attributes_map = {})
    @file = file
    @attributes_map = attributes_map || {}
    @black_list = black_list || []
    @users = []
    @errors = []
  end

  def parse
    open_spreadsheet
    parse_header
    normalize_attr_names
    apply_attributes_map_to_header

    @users = @spreadsheet[1..-1].map.with_index do |row, index|
      user = Hash[[@header, row].transpose].delete_if do |key, value|
        key.blank? || value.blank? || ignored?(key)
      end
    end

    users
  end

  def valid?
    validate
    errors.empty?
  end

  private


  def validate
    sheet = open_spreadsheet
    head = sheet.first
    index = 1

    sheet.each do |row|
      if head.length != row.length
        add_error("bad csv: header and row length does not match: #{index} line")
        next
      end
      index += 1
    end
  end

  def add_error(error)
    @errors << error
  end

  def ignored?(key)
    black_list.include?(key)
  end

  def open_spreadsheet
    @spreadsheet ||= CSV.open(file.path, 'r').readlines
  end

  def parse_header
    @header ||= open_spreadsheet.first.map do |i|
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