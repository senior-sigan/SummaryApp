class EventImportsController < ApplicationController
	before_filter :find_event
	
	def new
		@event_import = EventImport.new
	end

	def create
		@event_import = EventImport.new(import_params)
		if @event_import.save
			redirect_to @event
		else
			render :new
		end
	end

	private
	def import_params
		#params.require()
	end
	def find_event
		@event = Event.find(params[:event_id])
	end
end
