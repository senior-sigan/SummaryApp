class Event < ActiveRecord::Base
	belongs_to :group
	validates :group_id, presence: true
	validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
end
