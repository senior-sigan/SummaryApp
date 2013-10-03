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

  def score
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
    
    res = registrations.real.map_reduce(map, reduce).out(inline: true).to_a
    unless res.empty?
      res.first['value'].to_i
    else
      0
    end
  end

  def registrate_to!(event)
    @registration = registrations.find_or_initialize_by(event: event)

    if events.empty?
      @registration.was = true
      @registration.newcomer = true
    else
      @registration.was = true
      @registration.newcomer = false
    end

    @registration.save
    @registration
  end

  def participate!(event, category, score)
    @registration = registrate_to! event

    @registration.participate!(category, score)
    @registration
  end

  def leave!(event)
    registrations.in(event: event).delete
  end

  def real_registrations
    registrations.real
  end

  def fake_registrations
    registrations.fake
  end

  def set_real_for(event)
    begin
      registrations.find_by(event: event).update_attribute(:was, true)
      true  
    rescue Exception => e
      errors.add :base, "Registration for user #{self.email} in event #{event.name} not found"
      false
    end
  end
  def set_fake_for(event)
    begin
      registrations.find_by(event: event).update_attribute(:was, false)
      true  
    rescue Exception => e
      errors.add :base, "Registration for user #{self.email} in event #{event.name} not found"
      false
    end
  end
end