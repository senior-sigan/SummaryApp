class Event < ActiveRecord::Base
	validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
	validates :evdate, presence: true
end
