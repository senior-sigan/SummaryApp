class ParticipantsController < ApplicationController
  before_filter :authenticate_owner!
  respond_to :html, :json

  def show
  	@participant = User.find(params[:id])
    @events = Event.all
  	respond_with(@participant)
  end

  def index
    respond_with do |format|
      format.json do
        @participants = jsoned(User.all)
        render json: @participants
      end
    end
  end

  def activity
    respond_with do |format|
      format.json do
        @participants = jsoned_regs Registration.activity
        @participants.sort! { |a,b| b[:goodness] <=> a[:goodness] }
        render json: @participants
      end
    end
  end

  def top
    respond_with do |format|
      format.json do
        @participants = jsoned_score(User.all)
        @participants.sort! { |a,b| b[:score] <=> a[:score] }
        render json: @participants
      end
    end
  end

  private
  def jsoned participants
    list = participants.map do |party|
      {
        id: party.id.to_s,
        name: party.name.capitalize,
        surname: party.surname.capitalize,
        gravatar: party.gravatar(50),
        categories: party.categories.only(:id,:name)
      }
    end
  end

  def jsoned_score participants
    list = participants.map do |party|
      {
        id: party.id.to_s,
        name: party.name.capitalize,
        surname: party.surname.capitalize,
        gravatar: party.gravatar(50),
        score: party.score,
        categories: party.categories.map{ |cat| cat.as_json }
      }
    end
  end

  def jsoned_regs(participants)
    participants.map do |party|
      value = party['value']
      {
        id: party['_id'].to_s,
        name: value['name'].capitalize,
        surname: value['surname'].capitalize,
        gravatar: "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(value['email'])}?size=50",
        fakes: value['skip'],
        reals: value['was'],
        goodness: value['goodness']
      }
    end
  end

end
