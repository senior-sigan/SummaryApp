class OwnerAuthenticator
  DEV_EMAIL = 'dev@summaryapp.heroku.com'

  def initialize(auth_hash)
    @auth_hash = auth_hash
  end

  def person
    @person ||= build_person
  end

  private

  def build_person
    owner = Owner.find_or_create_by(email: @auth_hash.info['email'])
    owner.update_attributes authentication_token: @auth_hash.credentials['token']
    owner
  end
end