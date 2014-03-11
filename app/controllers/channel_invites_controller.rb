class ChannelInvitesController < ApplicationController
  before_filter :authenticate_user!

  def create
    @channel = current_user.channels.find(params[:channel_id])
    
    @invite = @channel.channel_invites.build(params[:channel_invite])
    @invite.sender = current_user
    
    if @invite.save
      
      respond_to do |format|
        
        format.html {
          redirect_to channel_path(@channel)
        }
      end
      
      else
        
        respond_to do |format|
            format.html {
              render :text => 'Ouch'
            }
      end
    end
    
    
  end
  
  def show
  
    @invite = ChannelInvite.pending.find_by_token params[:id]
    @channel = @invite.channel
    
  end

  def accept
    
    @invite = ChannelInvite.pending.find_by_token params[:id]
   
    
    if @invite
      
      @channel = @invite.channel
      raise "You\'re already in!" if @channel.users.include?(current_user)
      
      @invite.accept!(current_user)
      @channel.subscribe(current_user)
      
      respond_to do |format|
        format.html {
          redirect_to channel_path(@channel)
        }
      end  
      
    end
    
  end
  
  def decline
    
    @invite = ChannelInvite.pending.find_by_token params[:token]
       
    if @invite
      
      @invite.decline!(current_user)
      
      respond_to do |format|
        format.html {
          redirect_to channels_path
        }
      end  
      
    end
     
  end


end
