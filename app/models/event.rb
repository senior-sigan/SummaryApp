class Event
  include Mongoid::Document
  field :name, type: String
  field :date, type: DateTime
  field :place, type: String
  field :photo, type: String

  embeds_many :participants

  index({name: 1}, {unique: true})
  index({'participants.email' => 1})
  index({date: 1})

  validates :name,
    presence: true,
    length: { maximum: 50 }, 
    uniqueness: { case_sensitive: false }
  validates :date,
    presence: true

  default_scope -> { order(:date.asc) }

  def self.splitted_participants(email)
    #TODO - fix this terrible selector
    Event.where('participants.email' => email).map do |event|
      event.participants.where('email' => email).to_a
    end.flatten
  end

  def newcomers
    CalculatedParticipant.where('value.event.id' => self.id)
  end

  def categories
    participants.distinct('categories').flatten
  end
  
  def score_for_participant(email)
    begin
      participants.find_by(email: email).categories.sum(&:score)   
    rescue Exception => e
      0  
    end
  end
end