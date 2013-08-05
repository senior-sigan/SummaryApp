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
  validates :registration,
  	presence: true

  def user
  	registration.user
  end
  def event
  	registration.event
  end
end
