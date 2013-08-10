class Participation
  include Mongoid::Document
  field :score, type: Integer

  belongs_to :category
  belongs_to :registration

  validates :score,
  	presence: true,
  	numericality: { greater_than: 0 }
  validates :category,
  	presence: true
  validates :registration,
  	presence: true
  validates :registration_id,
    uniqueness: { scope: :category_id }

  def user
  	registration.user
  end
  def event
  	registration.event
  end
end
