class Category
  include Mongoid::Document
  field :name, type: String
  field :score, type: Integer

  embedded_in :registration

  validates :name,
  	presence: true,
  	length: { maximum: 50 }

  def all
    Registration.all.distinct('categories.name')
  end
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
