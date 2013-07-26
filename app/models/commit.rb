class Commit < ActiveRecord::Base
	has_many :histories
end
