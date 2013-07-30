class Category
  include Mongoid::Document
  field :name

  validates :name,
  	presence: true,
  	length: { maximum: 50 }, 
  	uniqueness: { case_sensitive: false }

  before_save { self.name = name.downcase }
end
