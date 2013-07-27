class ParticipantsController < ApplicationController
  def index
  	@participants = Participant.all
  end

  def show
  end
end
