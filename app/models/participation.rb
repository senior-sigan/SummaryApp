class Participation
  include Mongoid::Document
  field :score, type: Integer

  belongs_to :event
  belongs_to :user
  belongs_to :category

  validates :score,
  	presence: true,
  	numericality: true
  validates :event,
  	presence: true
  validates :user,
  	presence: true
  validates :category,
  	presence: true
end
