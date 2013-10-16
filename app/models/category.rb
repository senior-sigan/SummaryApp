class Category
  include Mongoid::Document
  field :name, type: String
  field :score, type: Integer

  embedded_in :participant

  validates :name,
  	presence: true,
  	length: { maximum: 50 }

end
