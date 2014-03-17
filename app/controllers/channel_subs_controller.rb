class ChannelSubsController < ApplicationController
  before_filter :authenticate_user!
  
  def destroy
  
    channel = current_user.own_channels.find(params[:channel_id]) 
    @sub = channel.channel_subs.find params[:id]
  
    @sub.destroy
    
    respond_to do |format|
      format.html {
        redirect_to channel_path(channel), :notice => 'User removed'
      }
    end
  
  
  end
  
  
end
