class ChannelsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @channels = current_user.channels
  end

  def new
    @channel = current_user.channels.build
  end
  
  def show
    @channel = current_user.channels.find params[:id]
    @invite = @channel.channel_invites.build
    
  end
  
  def create
    
    @channel = Channel.new(params[:channel])
    @channel.owner_id = current_user.id
    
    if @channel.save 
    
      respond_to do |format|
        format.html { redirect_to channels_url, :notice => "Channel created" }
      end

    else
      
      respond_to do |format|
        format.html { render :action => :new }
      end
    
    end
    
    
  end
  

  
end
