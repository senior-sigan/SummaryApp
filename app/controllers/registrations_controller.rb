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
    @attributes = CalculatedParticipant.attr_names
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
    @participants = @event.participants
    @categories = CalculatedCategory.only('_id').all.map(&:'_id')
  end

  def set_categories
    score = params[:score].to_i || 0
    participants = params[:participants] || []
    categories = (params[:categories] || []).split(',')

    participants = participants.map do |part_id|
      participant = @event.participants.find part_id
      categories.map do |cat_name|
        cat = participant.categories.find_or_initialize_by(name: cat_name)
        if score.zero?
          cat.delete
        else
          cat.score = score
        end
      end
      participant
    end

    if participants.map(&:valid?).all?
      flash[:success] = "Score for participants was setted"
      participants.each{ |part| part.save }
      redirect_to @event
    else
      flash[:danger] = "SomeThing wents bad"
      redirect_to @event
    end
  end

  private
  def reg_params
    params.require(:registration).permit(:was)
  end
  
  def import_params
    attr = params.permit(:file, :black_list, :attributes_map, :build_new)
    attr[:black_list] = JSON.parse attr[:black_list] || [].to_json
    attr[:attributes_map] = JSON.parse attr[:attributes_map] || {}.to_json
    attr
  end
  
  def find_event
    @event = Event.find(params[:event_id])
  end
end