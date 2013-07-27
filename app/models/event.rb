class Event < ActiveRecord::Base
	has_many :records
	has_many :participants, through: :records
	has_many :categories, through: :records

	validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
	validates :date, presence: true
end