class Category
  include Mongoid::Document
  field :name, type: String
  field :score, type: Integer

  embedded_in :participant

  validates :name,
    presence: true,
    length: { maximum: 50 }
  
  validates :score,
    presence: true,
    numericality: {greater_than: 0, less_than: 1000}

  def self.all
    Event.distinct('participants.categories.name')
  end
end
