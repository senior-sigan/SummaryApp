class ParticipantsController < ApplicationController
  before_filter :authenticate_owner!
  respond_to :html, :json

  def show
  	@user = User.find(params[:id])
    @events = Event.all
  	respond_with(@user)
  end

  def index
    respond_with do |format|
      format.json do
        @users = jsoned(User.all)
        render json: @users
      end
    end
  end

  def activity
    respond_with do |format|
      format.json do
        @users = jsoned_regs(User.all)
        @users.sort! { |a,b| b[:goodness] <=> a[:goodness] }
        render json: @users
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
