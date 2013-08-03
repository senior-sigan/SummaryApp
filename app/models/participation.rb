class Participation
  include Mongoid::Document
  field :score, type: Integer

  belongs_to :category
  belongs_to :registration

  validates :score,
  	presence: true,
  	numericality: true
  validates :category,
  	presence: true
end
