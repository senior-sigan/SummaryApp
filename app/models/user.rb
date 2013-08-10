class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :email, type: String
  field :name, type: String
  field :surname, type: String
  #meta fields wich will be added dynamicaly
  
  has_many :registrations

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, 
    presence: true,
  	format: { with: VALID_EMAIL_REGEX }, 
  	length: { maximum: 100 }, 
  	uniqueness: { case_sensitive: false }
  validates :name,
  	length: { maximum: 50 }, 
  	presence: true
  validates :surname,
  	length: { maximum: 50 }, 
  	presence: true

  before_save { self.email = email.downcase }

  def events
    Event.in(id: real_registrations.map(&:event_id))
  end
  def categories
    Category.in(id: participations.map(&:category_id))
  end
  def score
    participations.sum(:score)
  end
  def score_for_event(event)
    participations_for_event(event).sum(:score)
  end
  def pc_score_for_category(category)
    sc = score.to_f
    score_for_category(category)*100.0 / sc unless sc.zero?
  end
  def score_for_category(category)
    participations_for_category(category).sum(:score)
  end
  def participations
    Participation.in(registration_id: real_registrations.map(&:id))  
  end
  def participations_for_event(event)
    Participation.in(registration_id: real_registrations.where(event: event).map(&:id))
  end
  def participations_for_category(category)
    participations.where(category: category)
  end
  def participate!(event, category, score)
    if reg = find_or_create_registration_for(event)
      if part = reg.participate!(category, score)
        true
      else
        errors.add :base, part.errors.full_messages
        false
      end
    else
      errors.add :base, reg.errors.full_messages
      false
    end
  end
  def leave!(event)
    begin
      reg = Registration.find_by(event: event, user: self)
      reg.unparticipate!
      reg.delete
      true
    rescue Exception => e
      errors.add :base, "Registration for user #{self.email} in event #{event.name} not found"
      false
    end
  end
  def find_or_create_registration_for(event)
    begin
      Registration.find_by(user: self, event: event)
    rescue Exception => e
      registrate_to!(event)
    end
  end
  def registrate_to!(event)
    if events.empty?
      registrations.create!(event: event, was: true, newcomer: true)
    else
      registrations.create!(event: event, was: true, newcomer: false)
    end
  end
  def unregistrate_from(event)
    registrations.delete(event)
  end
  def set_real_for(event)
    begin
      registrations.find_by(event: event).update_attributes(:was, true)
      true  
    rescue Exception => e
      errors.add :base, "Registration for user #{self.email} in event #{event.name} not found"
      false
    end
  end
  def set_fake_for(event)
    begin
      registrations.find_by(event: event).update_attributes(:was, false)
      true  
    rescue Exception => e
      errors.add :base, "Registration for user #{self.email} in event #{event.name} not found"
      false
    end
  end
  def fake_registrations
    registrations.where(was: false)
  end
  def real_registrations
    registrations.where(was: true)
  end
  def goodness
    fakes = fake_registrations.count
    reals = real_registrations.count
    all = fakes + reals
    if all.zero?
      100
    else
      (reals.to_f / all.to_f) * 100
    end
  end
  def quad_goodness
    fakes = fake_registrations.count.to_f
    reals = real_registrations.count.to_f
    all = fakes + reals
    if all.zero?
      100
    else
      (reals**2 / all)
    end
  end  
  def real_registration_for(event)
    begin
      registrations.where(was: true).find_by(event: event)
    rescue Exception => e
      errors.add :base, "Registration for user #{self.email} in event #{event.name} not found"
      nil  
    end
  end
end