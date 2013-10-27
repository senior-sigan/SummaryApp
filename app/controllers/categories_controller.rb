class CategoriesController < ApplicationController
  before_filter :authenticate_owner!
  respond_to :html, :json

  def index
    respond_with do |format|
      format.json { render json: CalculatedCategory.all }
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

  private

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

end
