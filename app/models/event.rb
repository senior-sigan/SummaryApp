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
    User.in(id: registrations.real.where(newcomer: true).map(&:user_id))
  end

  def users
    User.in(id: registrations.distinct(:user_id))
  end
  
  def real_users
    User.in(id: registrations.real.distinct(:user_id))
  end
  
  def fake_users
    User.in(id: registrations.fake.distinct(:user_id))
  end

  def categories
    registrations.distinct('categories.name')
  end

end