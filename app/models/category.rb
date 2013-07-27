class Category < ActiveRecord::Base
	has_many :records
	has_many :participants, through: :records
	has_many :events, through: :records

	validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
end
