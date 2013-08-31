class CategoriesController < ApplicationController
  before_filter :authenticate_owner!
  respond_to :html, :json
  before_filter :find_category, only: [:participants]

  def index
    respond_with do |format|
      format.json { render json: counted(Category.all) }
    end
  end
  def participants
    respond_with do |format|
      format.json do 
        @participants = scored_participants_for @category
        @participants.sort! { |a,b| b[:score] <=> a[:score] }
        render json: @participants 
      end
    end
  end
  def new
  	@category = Category.new
  end

  def create
  	@category = Category.new category_params
  	if @category.save
      flash[:success] = "#{@category.name} saved"
  	  redirect_to new_category_path
  	else
  	  render :new
  	end
  end

  def edit
    @category = Category.find params[:id]
    respond_with @category
  end

  def update
    category = Category.find params[:id]
    if category.update_attributes event_params
      respond_with(category, status: :updated, location: category) do |format|
        format.html do
          flash[:success] = "Category updated" 
          redirect_to category 
        end
      end
    else
      respond_with(category, status: :unprocessable_entity) do |format|
        format.html { render :edit }
      end
    end
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end
  def find_category
    @category = Category.find params[:id]
  end

  def scored_participants_for(category)
    list = category.users.map do |user|
      {
        id: user.id.to_s,
        name: user.name,
        surname: user.surname,
        gravatar: user.gravatar(50),
        score: user.score_for_category(category)
      }
    end
  end

  def counted(categories)
    list = categories.map do |cat|
      {
        id: cat.id.to_s,
        name: cat.name,
        participants_count: cat.users.count
      }
    end
  end
end
