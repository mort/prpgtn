class Api::V0::ChannelsController < Api::V0::ApiController
  
  def index
    respond_with current_user.channels
  end
  
  
  def show
    respond_with current_user.channels.find_by(params[:id])
  end

  
  
end
