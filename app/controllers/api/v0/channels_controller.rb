class Api::V0::ChannelsController < Api::V0::ApiController
  
  def index
    
    respond_with current_user.channels, each_serializer: ChannelListSerializer
  
  end
  
  
  def show
  
    respond_with current_user.channels.find params[:id]
  
  end

  
  
end
