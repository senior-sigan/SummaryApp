class CategoriesController < ApplicationController
  before_filter :authenticate_owner!
  before_filter :find_category, only: [:participants]
  respond_to :html, :json

  def index
    @category = CalculatedCategory.all
    respond_with @category, each_serializer: CategorySerializer
  end

  def participants
    @participants =  CalculatedParticipant
      .where('value.categories.name' => @category.id)
      .order_by('value.categories.score DESC')
    respond_with @participants, each_serializer: ParticipantScoreSerializer, scope: @category
  end

  def recalculate
    CalculatedCategory.recalculate!
    render json: {status: :recalculated, location: categories_path}
  end

  private

  def find_category
    @category = CalculatedCategory.find params[:id]
  end
end
