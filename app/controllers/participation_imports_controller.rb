class ParticipationImportsController < ApplicationController
	before_filter :find_event
	
	def new
		@file = ParticipationImport.new
	end

	def create
		render text: params
		#@file = ParticipationImport.new(import_params)
		#@category = Category.find(params[:category][:id])
		#@score = params[:score]

		#if @users = @file.save
		#	@users.each do |user|
		#		user.participate!(@event,@category,@score)
		#	end
		#	redirect_to @event
		#else
		#    render :new
		#end
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
