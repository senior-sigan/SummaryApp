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

  def self.counted
    all.map do |category|
      count = Registration.where('categories.name' => category).distinct('user_id').count
      {name: category, participants_count: count}
    end
  end
end
