class Event
  include Mongoid::Document
  field :name, type: String
  field :date, type: DateTime
  field :place, type: String
  field :new_users, type: Integer, default: 0

  has_many :registrations

  validates :name,
  	presence: true,
  	length: { maximum: 50 }, 
  	uniqueness: { case_sensitive: false }
  validates :date,
  	presence: true
  validates :new_users,
    numericality: true
  
  def users
    User.in(id: participations.map(&:user_id))
  end
  def anti_users
    User.not_in(id: participations.map(&:user_id))
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
  def fake_users
    registrations.where(was: false)
  end
  def real_users
    registrations.where(was: true)
  end
end