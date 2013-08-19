class CategoriesController < ApplicationController
  respond_to :html, :json
  before_filter :find_category, only: [:participants]

  def index
    @categories = Category.all
    respond_with @categories
  end
  def show
    @category = Category.find(params[:id])
    respond_with @category
  end
  def participants
    @participants = @category.users
    respond_with do |format|
      format.json { render json: scored(@participants, @category) }
    end
  end
  def new
  	@category = Category.new
  end

  def create
  	@category = Category.new(category_params)
  	if @category.save
  	  redirect_to categories_path
  	else
  	  render :new
  	end
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end
  def find_category
    @category = Category.find params[:id]
  end
  def scored participants, category
    list = participants.map do |user|
      {
        id: user.id.to_s,
        name: user.name,
        surname: user.surname,
        gravatar: "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}?size=50",
        score: user.score_for_category(category)
      }  
    end
  end
end
