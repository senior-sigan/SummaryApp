class SpreadsheetValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless File.extname(value.original_filename).eql?('.csv')
      record.errors[attribute] << (options[:message] || 'File type must be .csv')
    end
  end
end