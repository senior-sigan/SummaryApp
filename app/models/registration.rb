class Registration
  include Mongoid::Document
  field :was, type: Boolean, default: true
  belongs_to :event
  belongs_to :user
  has_many :participations

  validates :was,
  	presence: true

  def self.fakes 
  	Registration.where(was: false)
  end
  def self.reals
  	Registration.where(was: true)
  end
  def categories
  	Category.in(id: participations.map(&:category_id))
  end
  def score
  	participations.sum(:score)
  end
end
