class Registration
  include Mongoid::Document
  field :was, type: Boolean, default: true
  field :newcomer, type: Boolean

  belongs_to :event
  belongs_to :user
  has_many :participations

  validates :was,
  	presence: true
  validates :user,
    presence: true
  validates :event,
    presence: true
  validates :newcomer,
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
  def participate!(category, score)
    participations.create!(category: category, score: score)
  end
  def unparticipate!
    participations.delete_all
  end
end

