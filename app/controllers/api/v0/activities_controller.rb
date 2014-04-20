class Api::V0::ActivitiesController < Api::V0::ApiController
  
  def index      
    respond_with current_user.channels.find(params[:channel_id]).activities.order("created_at DESC").limit(10)
  end
  
end
