require "csv"

class Record < ActiveRecord::Base
  belongs_to :participant
  belongs_to :category
  belongs_to :event

  validates_associated :participant
  validates_associated :category
  validates_associated :event
  validates :score, presence: true, numericality: true
  validates_presence_of :participant, :category, :event
  validates :participant, uniqueness: {scope: [:event, :category]}
	def self.import(file,event,category,score)
    CSV.foreach(file.path, headers: true) do |row|
    	row = row.to_hash
    	part = Participant.find_or_create(row)
     	r = Record.new(
     		participant_id: part.id, 
     		category_id: category.id,
     		event_id: event.id,
     		score: score)
     	r.save
    end
	end
end
