class Owner
  include Mongoid::Document

  field :email, type: String, default: ''
  field :authentication_token, type: String
  field :approved, type: Boolean, default: false

  validates :approved,
    presence: true


  def self.sign_in_by_oauth_hash(auth_hash)
    owner = Owner.find_or_create_by(email: auth_hash.info['email'])
    owner.update_attributes authentication_token: auth_hash.credentials['token']

    owner
  end
end
