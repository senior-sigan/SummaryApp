class Event
  include Mongoid::Document
  field :name, type: String
  field :date, type: DateTime
  field :place, type: String
  field :photo, type: String

  has_many :registrations, dependent: :destroy # WARNING!! CASCADE THERE

  index({name: 1}, {unique: true})

  validates :name,
  	presence: true,
  	length: { maximum: 50 }, 
  	uniqueness: { case_sensitive: false }
  validates :date,
  	presence: true
  def newcomers
    User.in(id: real_registrations.where(newcomer: true).map(&:user_id))
  end
  def users
    User.in(id: registrations.map(&:user_id))
  end
  def real_users
    User.in(id: real_registrations.map(&:user_id))
  end
  def fake_users
    User.in(id: fake_registrations.map(&:user_id))
  end
  def categories
    Category.in(id: participations.map(&:category_id))
  end
  def participations
    Participation.in(registration: registrations.map(&:id))  
  end
  def fake_registrations
    registrations.where(was: false)
  end
  def real_registrations
    registrations.where(was: true)
  end
  def registrate!(user)
    registrations.create!(user: user, was: true)
  end
  def unregistrate(user)
    registrations.delete(user)
  end
end