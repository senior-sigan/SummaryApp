class RecordsController < ApplicationController
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

  def record_params
    params.require(:record).permit(:email, :name, :surname, :meta)
  end

  def toggle_params
  end
end
