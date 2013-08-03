class CategoriesController < ApplicationController
  respond_to :html, :json

  def index
    @categories = Category.all
    respond_with(@categories)
  end
  def show
    @category = Category.find(params[:id])
    respond_with(@category)
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
end
