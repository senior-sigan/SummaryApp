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
    EmailHandler.new(email).escape
  end

  def self.find(params)
    params = EmailHandler.new(params).unescape
    super
  end
end