class Participation
  include Mongoid::Document
  field :score, type: BigDecimal

  belongs_to :event
  belongs_to :user
  belongs_to :category

  validates :score,
  	presence: true,
  	numericality: true
end
