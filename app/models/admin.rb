class Admin < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 100}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :approved, inclusion: {in: [true, false]}
  validates :authentication_token, uniqueness: {allow_nil: true}, length: {maximum: 255}

  before_save { self.email = email.downcase }
end
