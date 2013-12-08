class ParticipantsController < ApplicationController
  before_filter :authenticate_owner!
  respond_to :html, :json

  def recalculate
    CalculatedParticipant.recalculate!
    render json: {status: :recalculated, location: participants_path}
  end

  def show
    @participant = CalculatedParticipant.find(params[:id])
    @events = Event.all
    respond_with @participant
  end

  def edit
    email = URI.unescape Base64.decode64(params[:id])
    @participants = Event.where('participants.email' => email).map do |event|
      event.participants.where('email' => email).to_a
    end.flatten
    respond_with(@participants)
  end

  def update
   # render text: params
    @event = Event.find params[:participant][:event_id]
    @participant = @event.participants.find_by_params params[:id]

    if @participant.update_attributes participant_attributes
      respond_with(@participant, status: :updated) do |format|
        format.html do
          flash[:success] = "Participant updated. Recalculate statistic !!!" 
          redirect_to participants_path
        end
      end
    else
      respond_with(@participant, status: :unprocessable_entity) do |format|
        format.html { render :edit }
      end
    end
  end

  def index
    respond_with do |format|
      format.json do
        @participants = CalculatedParticipant.order_by('value.goodness DESC').all
        render json: @participants, each_serializer: ParticipantSerializer
      end
    end
  end

  def top
    respond_with do |format|
      format.json do
        @participants = CalculatedParticipant.order_by('value.score DESC').all
        render json: @participants, each_serializer: ParticipantSerializer
      end
    end
  end

  private

  def participant_attributes
    params.require(:participant).permit(:name,:surname,:email)
  end
end
