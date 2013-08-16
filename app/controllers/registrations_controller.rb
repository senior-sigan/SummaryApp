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
		@import = RegistrationImport.new(import_params)
		@import.event = @event

		if @import.save
			respond_with(@import, status: :created, location: '#')
		else
			respond_with(@import.errors, status: :unprocessable_entity)
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
		#render text: params
		@score = params[:categories]
		@registrations = params[:registrations] || []
		@registrations.each do |reg_id,cats|
			registration = Registration.find reg_id
			cats.each do |cat_id|
				unless registration.participate! Category.find(cat_id), @score[cat_id]
					render :categorize
				end
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
			params.require(:registration_import).permit(:file,:fields)
		end
	end
	def find_event
		@event = Event.find(params[:event_id])
	end
end