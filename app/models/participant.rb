class Participant < ActiveRecord::Base
	validates :email, presence: true, length: { maximum: 50 }, uniqueness: true

	def self.find_or_create(params)
		email = params['email']
		p = Participant.find_by_email(email)
		if p.nil? 
			p = Participant.create(email: email)
		end
		p
	end
end
