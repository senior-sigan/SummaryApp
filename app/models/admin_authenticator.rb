class AdminAuthenticator
  DEV_EMAIL = 'dev@summaryapp.heroku.com'

  attr_reader :auth_hash

  def initialize(auth_hash)
    @auth_hash = Rails.env.production? ?
      auth_hash :
      Struct.new(:info, :credentials).new({'email' => DEV_EMAIL}, { 'token' => '111111'})
  end

  def admin
    @admin ||= authenticate_admin
  end

  private

  def authenticate_admin
    admin = Admin.find_or_create_by(email: @auth_hash.info['email'])
    admin.update_attributes authentication_token: @auth_hash.credentials['token']
    admin
  end
end