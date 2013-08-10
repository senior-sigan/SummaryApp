class EventsController < ApplicationController
  respond_to :html, :json

  def show
  	@event = Event.find(params[:id])
    @participations = @event.participations
    respond_with(@event)
  end
  def index
    @events = Event.all.sort_by{ |e| e.date }
    @categories = Category.all
    respond_with(@events)
  end
  def new
  	@event = Event.new
    respond_with(@event)
  end
  def create 
  	@event = Event.new(event_params)

  	if @event.save
  	  redirect_to @event
  	else
  	  render :new
  	end
  end
  def statistics #for event
    @event = Event.find(params[:id])
    respond_with(@event)
  end
  def stats #for all events
    @events = Event.all
    @ev = @events.map(&:name)
  end

  private 
  def event_params
    params.require(:event).permit(:name,:date)
  end
end
