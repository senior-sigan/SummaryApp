class ParticipationImportsController < ApplicationController
	before_filter :find_event
	
	def new
		@import = ParticipationImport.new
		@import.event = @event
	end

	def create
		#render text: params
		@import = ParticipationImport.new(import_params)
		@import.event = @event
		@category = Category.find(params[:category][:id])
		@score = params[:score]

		if @registrations = @import.save
			@registrations.each do |reg|
				reg.participate!(@category,@score)
			end
			#render text: @users.to_json 
			redirect_to @event
		else
		  render :new
		end
	end

	private
	def import_params
		if params.has_key?(:participation_import)
			params.require(:participation_import).permit(:file)
		end
	end
	def find_event
		@event = Event.find(params[:event_id])
	end
end
