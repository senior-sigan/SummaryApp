class Participant < ActiveRecord::Base
	has_many :records
	has_many :events, through: :records
	has_many :categories, through: :records

	validates :uuid, presence: true, length: { maximum: 50 }, uniqueness: true
	validates :surname, presence: true, length: { maximum: 50 }
	validates :name, presence: true, length: { maximum: 50 }

	def self.find_or_create(params)
		uuid = params.delete('uuid')
		name = params.delete('name')
		surname = params.delete('surname')
		meta = params.to_s

		pa = Participant.find_by_uuid(uuid)
		if pa.nil? 
			pa = Participant.new(uuid: uuid, name: name, surname: surname)
		end
		pa.meta ||= ''
		pa.meta << meta
		if pa.save
			return pa
		else
			p pa.errors
			return nil
		end
	end
end
