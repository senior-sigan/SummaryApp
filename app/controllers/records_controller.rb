class RecordsController < ApplicationController
  before_action :find_event, only: [:new, :create]

  def new
    @record = @event.records.build
  end

  def create
    @record = @event.records.build new_record_params

    if @record.save
      flash[:success] = "Record for #{@record.email} created"
      redirect_to @event
    else
      render :new
    end
  end

  def edit
    @record = Record.find params[:id]
  end

  def update
    @record = Record.find params[:id]
    if @record.update_attributes record_params
      flash[:success] = "Record updated" 
      redirect_to @record.event 
    else
      render :edit
    end
  end

  def toggle_presence
    @record = Record.find params[:id]
    @record.toggle_presence
    render json: {status: @record.presence}
  end

  def destroy
    @record = Record.find params[:id]

    if @record.destroy
      flash[:success] = "Record #{@record.email} destoroyed"
      redirect_to @record.event
    else
      flash[:danger] = "Record #{@record.email} can not be deleted now. Try again later."
      redirect_to @record.event
    end
  end

  private
  def find_event
    @event = Event.find params[:event_id]
  end

  def record_params
    params.require(:record).permit(:email, :name, :surname, :meta)
  end

  def new_record_params
    params.require(:record).permit(:email, :name, :surname)
  end

  def toggle_params
  end
end
