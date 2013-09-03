class Category
  include Mongoid::Document
  field :name, type: String
  field :isPublic, type: Boolean, default: false

  index({name: 1}, {unique: true})

  validates :name,
  	presence: true,
  	length: { maximum: 50 }, 
  	uniqueness: { case_sensitive: false }
  validates :isPublic,
  	presence: true

  has_many :participations

  def events
    Event.in(id: event_ids)
  end
  def users
    User.in(id: user_ids)
  end
  def user_ids
    Registration.in(id: participations.distinct(:registration_id)).where(was: true).distinct(:user_id)
  end
  def event_ids
    Registration.in(id: participations.distinct(:registration_id)).where(was: true).distinct(:event_id)
  end
end
