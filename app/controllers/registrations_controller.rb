class RegistrationsController < ApplicationController
	before_filter :authenticate_owner!
	before_filter :find_event
	respond_to :html, :json

	def index
		@participants = @event.participants
	end

	def import
		@import = RegistrationImport.new
		@import.event = @event
	end

	def save_import
		@import = RegistrationImport.new import_params
		@import.event = @event

		if @import.save
			respond_with(@import, status: :created, location: @event)
		else
			respond_with(
				@import, 
				status: :unprocessable_entity,
				location: import_event_registrations_path(@event))
		end
	end

	def set_was
		params[:participants] ||= { "was" => [] }
		participant_ids = params[:participants]["was"]
		real_participants = @event.participants.in(id: participant_ids)
		fake_participants = @event.participants.not_in(id: participant_ids)
		real_participants.each{ |r| r.update_attribute(:was,true) }
		fake_participants.each{ |f| f.update_attribute(:was,false) }
		redirect_to @event
	end

	def categorize
		@cats = Category.all
		@participants = @event.participants
	end

	def set_categories
		#render text: params
		@score = params[:categories]
		@participants = params[:participants] || []
		@participants.each do |part_id,cats|
			participant = @event.participants.find part_id
			cats.each do |cat_name|
				cat = participant.categories.find_or_initialize_by(name: cat_name)
				cat.score = @score[cat_name]
				cat.save
			end	
		end
		redirect_to @event
	end

	private
	def reg_params
		params.require(:registration).permit(:was)
	end
	
	def import_params
		params.permit(:file,:fields)
	end
	
	def find_event
		@event = Event.find(params[:event_id])
	end
end