class Group < ActiveRecord::Base
	has_many :events
	validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
end
