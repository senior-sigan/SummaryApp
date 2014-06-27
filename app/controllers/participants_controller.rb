class ParticipantsController < ApplicationController
  def index
    @participants = Participant.all
  end

  def show
    @participant = Participant.find params[:id]
    @records = @participant.records
  end

  def edit
    @participant = Participant.find params[:id]
    @records = @participant.records
  end

  #TODO: refactor
  def update
    @event = Event.find params[:participant][:event_id]
    @participant = @event.participants.find_by_params params[:id]

    if @participant.update_attributes participant_attributes
      flash[:success] = "Participant updated. Recalculate statistic !!!" 
      redirect_to participants_path
    else
      render :edit
    end
  end

  private

  def participant_attributes
    params.require(:participant).permit(:name, :surname, :email)
  end
end
