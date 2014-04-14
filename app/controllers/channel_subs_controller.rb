class ChannelSubsController < ApplicationController
  before_filter :authenticate_user!
  
  def destroy
  
    channel = current_user.own_channels.find(params[:channel_id]) 
    @sub = channel.channel_subs.find params[:id]
    
    @sub.on(:leave_channel) { |sub| redirect_to channel_path(sub.channel), :notice => 'Suscrition removed' }
    
    @sub.cancel      
    
  end
  
  
end
