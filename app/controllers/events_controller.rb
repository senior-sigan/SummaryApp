require "csv"
class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_group

  def show
  	@event = Event.find(params[:id])
  end
  def driver
    client = Google::APIClient.new
    client.authorization.access_token = session[:token]
    service = client.discovered_api('drive', 'v2')
    @result = client.execute(
      :api_method => service.files.list,
      :parameters => {'q' => "mimeType='application/vnd.google-apps.form'"},
      :headers => {'Content-Type' => 'application/json'}) 
  end
  def new
  	@event = Event.new
  end
  def create 
    file = params[:event][:file]
    rows = []
    CSV.foreach(file.path, headers: true) do |row|
      rows.push(row.to_hash)
    end
    render text: rows.to_json
  	#@event = @group.events.build(event_params)

  	#if @event.save
  	#  redirect_to [@group,@event]
  	#else
  	#  render :new
  	#end
  end

  private 
  def find_group
    @group = Group.find params[:group_id]
  end
  def event_params
    params.require(:event).permit(:name)
  end
end
