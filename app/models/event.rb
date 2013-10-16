class Event
  include Mongoid::Document
  field :name, type: String
  field :date, type: DateTime
  field :place, type: String
  field :photo, type: String

  embeds_many :participants

  index({name: 1}, {unique: true})

  validates :name,
  	presence: true,
  	length: { maximum: 50 }, 
  	uniqueness: { case_sensitive: false }
  validates :date,
  	presence: true

  def categories
    participants.distinct('categories').flatten
  end
end