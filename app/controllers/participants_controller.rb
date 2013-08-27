class ParticipantsController < ApplicationController
  respond_to :html, :json

  def show
  	@user = User.find(params[:id])
    @events = Event.all
  	respond_with(@user)
  end

  def index
    @users = jsoned(User.all)
    @users.sort! { |a,b| b[:goodness] <=> a[:goodness] }
    respond_with @users
  end

  private
  def jsoned participants
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
