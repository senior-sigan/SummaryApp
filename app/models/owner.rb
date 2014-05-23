class Owner
  include Mongoid::Document

  field :email, type: String, default: ''
  field :authentication_token, type: String
  field :approved, type: Boolean, default: false

  validates :approved,
    presence: true
end
