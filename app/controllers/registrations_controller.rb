class RegistrationsController < ApplicationController
	before_filter :find_event
	respond_to :html, :json

	def index
		@registrations = @event.registrations
	end

	def import
		@import = RegistrationImport.new
		@import.event = @event
	end

	def save_import
		#render text: params
		@import = RegistrationImport.new(import_params)
		@import.event = @event
#		@category = Category.find(params[:category][:id])
#		@score = params[:score]

		if @registrations = @import.save
			#@registrations.each do |reg|
			#	reg.participate!(@category,@score)
			#end
			#render text: @users.to_json 
			flash[:success] = "Saved #{@registrations.count} registrations"
			redirect_to @event
		else
		  render :new
		end
	end

	def set_was
		params[:registrations] ||= { "was" => [] }
		reg_ids = params[:registrations]["was"]
		real_regs = @event.registrations.in(id: reg_ids)
		fake_regs = @event.registrations.not_in(id: reg_ids)
		real_regs.each{ |r| r.update_attribute(:was,true) }
		fake_regs.each{ |f| f.update_attribute(:was,false) }
		redirect_to @event
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
	def import_params
		if params.has_key?(:registration_import)
			params.require(:registration_import).permit(:file)
		end
	end
	def find_event
		@event = Event.find(params[:event_id])
	end
end