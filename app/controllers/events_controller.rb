class EventsController < ApplicationController
  before_filter :authenticate_owner!
  respond_to :html, :json

  def show
    @event = Event.find(params[:id])
    @participants = @event.participants
    respond_with(@event)
  end

  def index
    @events = Event.order_by(:date.asc).all
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
    respond_with calculated @events
  end

  private 
  def event_params
    params.require(:event).permit(:name,:date,:photo)
  end

  def calculated events
    list = events.map do |event|

      real_users_cnt = event.participants.real.count.to_f
      newcomers_cnt = event.newcomers.count.to_f
      users_cnt = event.participants.count.to_f

      new_ratio = unless real_users_cnt.zero?
        newcomers_cnt / real_users_cnt
      else
        0
      end

      real_ratio = unless users_cnt.zero?
        real_users_cnt / users_cnt
      else
        0
      end

      {
        id: event.id.to_s,
        name: event.name,
        date: event.date,
        newcomer_ratio: new_ratio*100.0,
        real_ratio: real_ratio*100.0,
        reals: real_users_cnt,
        newcomers: newcomers_cnt,
        users: users_cnt
      }
    end

  end
end
