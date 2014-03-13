class ChannelInvitesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @sent = current_user.sent_channel_invites.pending
    @received = current_user.received_channel_invites.pending
  end

  def create
    @channel = current_user.channels.find(params[:channel_id])
    
    @invite = @channel.channel_invites.build(params[:channel_invite])
    @invite.sender = current_user
    
    r = User.find_by_email(@invite.email)
    @invite.recipient = r if r
    
    if @invite.save
      
      UserMailer.channel_invite(@invite)

      respond_to do |format|
        
        format.html {
          redirect_to channel_path(@channel), :notice => 'Invitation sent'
        }
        
      end
      
      else
        
        respond_to do |format|
            format.html {
             redirect_to channel_path(@channel)
            }
      end
    end
    
    
  end
  
  def show
    
    @invite = ChannelInvite.pending.find_by_token_and_email params[:id], current_user.email
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
    
    @invite = ChannelInvite.pending.find_by_token params[:id]
       
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
