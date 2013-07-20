class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @events = @group.events
  end

  def new
  	@group = Group.new
  end

  def create
  	#render text: params[:group].inspect
    @group = Group.new(group_params)

    if @group.save
      redirect_to @group
    else
      render :new
    end
  end

  private 
  def group_params
    params.require(:group).permit(:name)
  end
end
