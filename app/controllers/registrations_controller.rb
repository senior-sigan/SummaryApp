class RegistrationsController < ApplicationController
	before_filter :find_event
	respond_to :html, :json

	def index
		@registrations = @event.registrations
	end

	def update
		@registration = Registration.find(params[:id])
		if @registration.update_attribute(:was, reg_params["was"] == "1")
			flash[:success] = "Updated #{@registration.user.name}"
			redirect_to event_registrations_path(@event)
		else
			render :index
		end
	end

	def set_was
		params[:registrations] ||= { "was" => [] }
		reg_ids = params[:registrations]["was"]
		real_regs = @event.registrations.in(id: reg_ids)
		fake_regs = @event.registrations.not_in(id: reg_ids)
		real_regs.each{ |r| r.update_attribute(:was,true) }
		fake_regs.each{ |f| f.update_attribute(:was,false) }
		redirect_to event_registrations_path(@event)
	end

	def categorize
		@registrations = @event.registrations
		@cats = Category.all
	end
	def set_categories
		@regs = params[:registrations]
		bum = []
		@regs.each do |reg_id,category|
			category.each do |category_id,score|
				category = Category.find category_id
				registration = Registration.find(reg_id) 
				registration.participate!(category, score) unless score == "0"
				# FIX TO MODEL METOD!!! EXCEPTION DANGER
				# RENDER :categorize IF SOME ERRORS and ROLLBACK
			end
		end
		redirect_to @event
	end

	private
	def reg_params
		params.require(:registration).permit(:was)
	end
	def find_event
		@event = Event.find(params[:event_id])
	end
end