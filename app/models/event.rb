class Event
  include Mongoid::Document
  field :name, type: String
  field :date, type: DateTime
  field :place, type: String

  has_many :participations

  validates :name,
  	presence: true,
  	length: { maximum: 50 }, 
  	uniqueness: { case_sensitive: false }
  validates :date,
  	presence: true
  
  def users
    User.in(id: participations.map(&:user_id))
  end
  def categories
    Category.in(id: participations.map(&:category_id))
  end
  def invite!(user, category, score)
    participations.create!(user: user, category: category, score: score)
  end
  def exclude!(user)
    participations.destroy_all(user: user)
  end
end