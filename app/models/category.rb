class Category
  include Mongoid::Document
  field :name, type: String
  field :score, type: Integer

  embedded_in :registration

  validates :name,
  	presence: true,
  	length: { maximum: 50 }

  def self.all
    Registration.all.distinct('categories.name')
  end
end
