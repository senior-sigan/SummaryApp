class EventsController < ApplicationController
  def index
    @events = Event.all
  end
  
  def show
    @event = Event.find(params[:id])
    @records = StatisticsFactory.newcomers_at_event(@event)
  end

  def new
    @event = Event.new
  end

  def create 
    @event = Event.new(event_params)

    if @event.save
      flash[:success] = "Event created" 
      redirect_to @event
    else
      render :new
   end
 end

  def edit
    @event = Event.find params[:id]
  end

  def update
    @event = Event.find params[:id]
    if @event.update_attributes event_params
      flash[:success] = "Event updated" 
      redirect_to @event 
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find params[:id]
    if @event.destroy
      flash[:success] = "Event #{@event.name} destoroyed caskade"
      redirect_to events_path
    else
      render :edit
    end
  end

  private 
  def event_params
    params.require(:event).permit(:name, :date, :photo_url, :hash_tag, :social_url)
  end
end
