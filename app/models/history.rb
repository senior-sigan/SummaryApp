require "csv"

class History < ActiveRecord::Base
	belongs_to :commit

	def self.import(file,event,category,score)
		commit = Commit.create
      	CSV.foreach(file.path, headers: true) do |row|
      		row = row.to_hash
      		part = Participant.find_or_create(row)
        	h = commit.histories.build(
        		participant_id: part.id, 
        		category_id: category.id,
        		event_id: event.id,
        		score: score)
        	h.save
      	end
	end
end
