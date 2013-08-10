class ParticipantsController < ApplicationController
  respond_to :html, :json

  def index
  	#@users = User.all.sort{ |a,b| b.quad_goodness <=> a.quad_goodness }
  	@users = User.all
  	respond_with(@users)
  end

  def show
  	@user = User.find(params[:id])
  	respond_with(@user)
  end
end
