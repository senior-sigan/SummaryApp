class EmailHandler
  attr_reader :email

  def initialize(email)
    raise 'Email is blank' if email.blank?
    @email = email
  end

  def escape
    URI.escape Base64.encode64 @email
  end

  def unescape
    URI.unescape Base64.decode64 email
  end
end