class ChannelsController < ApplicationController

  before_filter :authenticate_user!
  
  def index
    @channels = current_user.channels.standard
  end

  def new
    @channel = current_user.channels.build
  end
  
  def show
          
    @channel = current_user.channels.standard.find params[:id]
  
    @invite = @channel.channel_invites.build
    @request = @channel.roboto_requests.build

    @items = @channel.items.with_link
  
    t = Channel::CHANNEL_TYPES.invert[@channel.channel_type]
  
    respond_to do |format|
  
      format.html { render :template => "channels/show.#{t}" }
      format.atom
  
    end

  end
  
  def create
    
    @channel = current_user.own_channels.build(channel_params)
    @channel.post_permissions = Channel::POST_PERMISSIONS[:public]
  
    @channel.on(:create_channel) { |channel| redirect_to channels_url, :notice => "Channel created" }
    @channel.on(:create_channel_fail) { |channel| render :action => :new  }
    
    @channel.commit
    
  end
  
  def destroy
        
    channel = current_user.own_channels.find(params[:id])
    return if channel.selfie?
    
    channel.on(:remove_channel) { redirect_to channels_url, :notice => "Channel deleted" }
    channel.remove
    
    
  end
  

  def leave
    
    channel = current_user.channels.find(params[:id])
    
    # Channel's owner can't leave before destroying it
    return if channel.owned_by?(current_user) 

    channel.unsubscribe(current_user)
    
    respond_to do |format|
      format.html { redirect_to channels_url, :notice => "You've left the channel" }
    end

    
  end


  private
  
  def channel_params
    params.require(:channel).permit(:title, :description)
  end
  
  
end
