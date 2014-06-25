class Participant < ActiveRecord::Base
  self.primary_key = 'email'
  default_scope { order 'participations DESC' }

  has_many :records, foreign_key: :email

  def readonly?
    true
  end

  def id
    to_param
  end

  def to_param
    URI.escape Base64.encode64 email
  end

  def self.find(params)
    params = URI.unescape Base64.decode64 params
    super
  end
end