class EventsController < ApplicationController
  before_filter :find_group

  def index
  end

  def show
  	@event = Event.find(params[:id])
  end

  def new
  	@event = Event.new
  end
  def create 
  	@event = @group.events.build(event_params)

  	if @event.save
  	  redirect_to [@group,@event]
  	else
  	  render :new
  	end
  end

  private 
  def find_group
    @group = Group.find params[:group_id]
  end
  def event_params
    params.require(:event).permit(:name)
  end
end
