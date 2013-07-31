class ParticipationImport
	include ActiveModel::Model
	attr_accessor :file

	def save
	  #load imported data
	  #validate each Participation row 
	  #on invalid push error and return false
	  #else return true
	end

	def open_spreadsheet
	end
end