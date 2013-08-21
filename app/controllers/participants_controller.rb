class ParticipantsController < ApplicationController
  respond_to :html, :json

  def index
  	#@users = User.all.sort{ |a,b| b.quad_goodness <=> a.quad_goodness }
  	@users = User.all
  	respond_with(@users)
  end

  def show
  	@user = User.find(params[:id])
    @events = Event.all
  	respond_with(@user)
  end

  def activity
  end
end
