class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :email, type: String
  field :name, type: String
  field :surname, type: String
  #meta fields wich will be added dynamicaly
  
  has_many :registrations

  index({ email: 1}, {unique: true})

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
  def gravatar(size)
    size ||= 50
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?size=#{size}"
  end
  
  def events
    Event.in(id: event_ids)
  end
  
  def event_ids
    registrations.distinct(:event_id)
  end
  
  def categories
    registrations.real.distinct('categories.name')
  end

  def score_in_categories
    Registration.score(self).map do |el| 
      {
        category: el['_id'][1], 
        score: el['value']
      }
    end
  end

  def score()
    map = %Q{
      function(){
        for(var i=0,len=this.categories.length; i < len; ++i)
          emit(this.user_id,this.categories[i].score);          
      }
    }
    reduce = %Q{
      function(key,values){
        return Array.sum(values);
      }
    }
    unless events.nil?
      registrations.real.where(event: events).map_reduce(map, reduce).out(inline: true)
    else
      registrations.real.map_reduce(map, reduce).out(inline: true)
    end
  end
  def pc_score_for_category(category)
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
  def activity
    fakes = fake_registrations.count.to_f
    reals = real_registrations.count.to_f
    all = fakes + reals
    goodness = if all.zero?
      0
    else
      (reals**2 / all)
    end
    {fakes: fakes, reals: reals, goodness: goodness}
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