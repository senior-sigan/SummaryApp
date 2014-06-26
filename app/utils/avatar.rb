class Avatar
  attr_reader :email
  GRAVATAR_URL = 'https://www.gravatar.com/avatar/'
  IDENTICONS_URL = 'https://identicons.github.com/'

  def initialize(email)
    @email = email
  end

  def url(size = 50)
    email_digest = Digest::MD5.hexdigest(email)
    "#{GRAVATAR_URL}#{email_digest}?size=#{size}&d=#{IDENTICONS_URL}#{email_digest}.png"
  end
end