class RecordBuilder
  DOMAIN = 'summaryapp.heroku.com'

  attr_accessor :email
  attr_accessor :name
  attr_accessor :surname  
  attr_accessor :meta
  attr_reader :params

  def initialize(params)
    params.each do |attr, value|
      self.public_send "#{attr}=", value
    end if params

    @params = {}
  end

  def build_for(event)
    set_email && set_name && set_surname
    @params[:meta] = meta

    event.records.build @params
  end

  private

  def set_email
    @params[:email] = email || try_find_email || make_email
  end

  def set_name
    @params[:name] = name || try_find_name
  end

  def set_surname
    @params[:surname] = surname || try_find_surname
  end

  def try_find_email
    r = Record.select(:email).find_by(name: name, surname: surname)
    r.email unless r.nil?
  end

  def try_find_name
    r = Record.select(:name).find_by(email: email)
    r.name unless r.nil?
  end

  def try_find_surname
    r = Record.select(:surname).find_by(email: email)
    r.surname unless r.nil?
  end

  def make_email
    return nil if name.blank? || surname.blank?
    Translit.t("#{name.mb_chars.downcase.to_s}.#{surname.mb_chars.downcase.to_s}@#{DOMAIN}").gsub(/[\'\"]/, '')
  end
end