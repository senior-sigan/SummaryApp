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
    respond_with do |format|
      format.json do
        render json: @participant
      end
    end
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
        render json: jsoned(@participants)
      end
    end
  end

  def top
    respond_with do |format|
      format.json do
        @participants = CalculatedParticipant.order_by('value.score DESC').all
        render json: jsoned(@participants)
      end
    end
  end

  private
  def jsoned participants
    list = participants.map do |party|
      {
        id: party.to_param,
        name: party.name.capitalize,
        surname: party.surname.capitalize,
        gravatar: party.gravatar(50),
        categories: party.categories,
        score: party.score
      }
    end
  end

  def jsoned_score participants
    list = participants.map do |party|
      {
        id: party.id.to_s,
        name: party.name.capitalize,
        surname: party.surname.capitalize,
        gravatar: party.gravatar(50),
        score: party.score,
        categories: party.categories
      }
    end
  end

  def jsoned_regs(participants)
    participants.map do |party|
      value = party['value']
      {
        id: party['_id'].to_s,
        name: value['name'].capitalize,
        surname: value['surname'].capitalize,
        gravatar: "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(value['email'])}?size=50",
        fakes: value['skip'],
        reals: value['was'],
        goodness: value['goodness']
      }
    end
  end

  def participant_attributes
    params.require(:participant).permit(:name,:surname,:email)
  end
end
