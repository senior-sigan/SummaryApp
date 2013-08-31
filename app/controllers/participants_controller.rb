class ParticipantsController < ApplicationController
  before_filter :authenticate_owner!
  respond_to :html, :json

  def show
  	@participants = User.find(params[:id])
    @events = Event.all
  	respond_with(@participants)
  end

  def index
    respond_with do |format|
      format.json do
        @participants = jsoned(User.all)
        render json: @participants
      end
    end
  end

  def activity
    respond_with do |format|
      format.json do
        @participants = jsoned_regs(User.all)
        @participants.sort! { |a,b| b[:goodness] <=> a[:goodness] }
        render json: @participants
      end
    end
  end

  def top
    respond_with do |format|
      format.json do
        @participants = jsoned_score(User.all)
        @participants.sort! { |a,b| b[:score] <=> a[:score] }
        render json: @participants
      end
    end
  end

  private
  def jsoned participants
    list = participants.map do |party|
      {
        id: party.id.to_s,
        name: party.name.capitalize,
        surname: party.surname.capitalize,
        gravatar: party.gravatar(50),
        categories: party.categories.map{ |cat| cat.as_json }
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
        categories: party.categories.map{ |cat| cat.as_json }
      }
    end
  end

  def jsoned_regs participants
    list = participants.map do |party|
      activity = party.activity
      {
        id: party.id.to_s,
        name: party.name.capitalize,
        surname: party.surname.capitalize,
        gravatar: party.gravatar(50),
        categories: party.categories.map{ |cat| cat.as_json },
        fakes: party.activity[:fakes],
        reals: party.activity[:reals],
        goodness: party.activity[:goodness]
      }
    end
  end

end
