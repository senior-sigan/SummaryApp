class EventsController < ApplicationController

  def show
  	@event = Event.find(params[:id])
  end
  def index
    @events = Event.all
    @categories = Category.all
    @history = History.all
  end
  def new
  	@event = Event.new
  end
  def create 
  	@event = Event.new(event_params)

  	if @event.save
  	  redirect_to @event
  	else
  	  render :new
  	end
  end
  def import
    @event = Event.find(params[:id])
  end
  def parse
    @event = Event.find(params[:id])
    unless params[:event].nil?
      file = params[:event][:file]
      score = params[:score]
      category = Category.find(params[:category][:id])
      History.import(file,@event,category,score)
      redirect_to events_path
    else
      render :import
    end
  end

  private 
  def event_params
    params.require(:event).permit(:name,:evdate)
  end
end
