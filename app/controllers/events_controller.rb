class EventsController < ApplicationController
  before_filter :authenticate_owner!
  respond_to :html, :json

  def show
    @event = Event.find(params[:id])
    @participants = @event.participants
    respond_with(@event)
  end

  def index
    @events = Event.all
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

  def edit
    @event = Event.find params[:id]
    respond_with @event
  end

  def update
    @event = Event.find params[:id]
    if @event.update_attributes event_params
      respond_with(@event, status: :updated) do |format|
        format.html do
          flash[:success] = "Event updated" 
          redirect_to @event 
        end
      end
    else
      respond_with(@event, status: :unprocessable_entity) do |format|
        format.html { render :edit }
      end
    end
  end

  def destroy
    @event = Event.find params[:id]
    if @event.destroy
      respond_with(@event, status: :destroyed) do |format|
        format.html do
          flash[:success] = "Event #{@event.name} destoroyed caskade"
          redirect_to events_path
        end
      end
    else
      respond_with(@event, status: :unprocessable_entity) do |format|
        format.html { render :edit }
      end
    end
  end

  def stats #for all events
    @events = Event.order_by(:date.asc).all
    respond_with @events, each_serializer: EventStatsSerializer
  end

  private 
  def event_params
    params.require(:event).permit(:name, :date, :photo, :hash_tag)
  end
end
