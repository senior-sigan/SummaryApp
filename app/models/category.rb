class Category
  include Mongoid::Document
  field :name, type: String
  field :isPublic, type: Boolean, default: false

  validates :name,
  	presence: true,
  	length: { maximum: 50 }, 
  	uniqueness: { case_sensitive: false }
  validates :isPublic,
  	presence: true

  has_many :participations
end
