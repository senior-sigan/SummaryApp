class Participant
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :email, type: String
  field :name, type: String
  field :surname, type: String
  #meta fields wich will be added dynamicaly
  
  field :was, type: Boolean, default: true
  embedded_in :event, inverse_of: :participants
  embeds_many :categories

  index({ email: 1}, {unique: true})

  scope :fake, where(was: false)
  scope :real, where(was: true) 
  scope :newcomer, where(was: true) #TODO

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, 
    presence: true,
    format: { with: VALID_EMAIL_REGEX }, 
    length: { maximum: 100 }, 
    uniqueness: { case_sensitive: false }
  validates :name,
    length: { maximum: 50 }, 
    presence: true
  validates :surname,
    length: { maximum: 50 }, 
    presence: true

  before_save { self.email = email.downcase }

  def gravatar(size)
    size ||= 50
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?size=#{size}"
  end

  def event_id
    event.id
  end

  def to_param
    URI.escape Base64.encode64(email)
  end

  def self.find_by_params(params)
    params = URI.unescape Base64.decode64(params)
    self.find_by email: params
  end

end