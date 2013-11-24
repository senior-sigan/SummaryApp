class CategoriesController < ApplicationController
  before_filter :authenticate_owner!
  respond_to :html, :json

  def index
    respond_with do |format|
      format.json { render json: jsoned(CalculatedCategory.all) }
    end
  end

  def participants
    @category = CalculatedCategory.find params[:id]

    respond_with do |format|
      format.json do 
        @participants = scored_participants_for @category
        render json: @participants 
      end
    end
  end

  def recalculate
    CalculatedCategory.recalculate!
    render json: {status: :recalculated, location: categories_path}
  end

  private

  def jsoned(categories)
    list = categories.map do |cat|
      {
        id: cat.id,
        participants_count: cat.participants_count
      }
    end
  end

  def scored_participants_for(category)
    CalculatedParticipant
      .where('value.categories.name' => category.id)
      .order_by('value.categories.score DESC')
      .map do |part|
      {
        id: part.to_param,
        name: part.name,
        surname: part.surname,
        gravatar: part.gravatar(50),
        score: part.score_for_category(category)
      }
    end
  end

end
