class ImportsController < ApplicationController
  before_action :find_event

  def new
    @ri = RecordsImporter.new(@event)
  end

  def create
    @ri = RecordsImporter.new(@event)
    @ri.file = file_params[:file]

    if @ri.save
      flash[:success] = "Form saved" 
      redirect_to @event
    else
      render :new
    end
  end

  private
  def find_event
    @event = Event.find params[:id]
  end

  def file_params
    params.require(:records_importer).permit(:file)
  end
end
