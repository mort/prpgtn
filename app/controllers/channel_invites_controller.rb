class ChannelInvitesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    
    @sent = current_user.sent_channel_invites.pending
    @received = current_user.received_channel_invites.pending

  end

  def create
    
    @channel = current_user.channels.find(params[:channel_id])
    
    @invite = @channel.channel_invites.build(invite_params)
    @invite.sender = current_user
    
    r = User.find_by_email(@invite.email)
    @invite.recipient = r if r
    
    if @invite.commit
      
      UserMailer.channel_invite(@invite).deliver

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
    
    @invite = ChannelInvite.pending.find_by_token params[:id]
    
    if (@invite && (@invite.email == current_user.email))
      @channel = @invite.channel
    elsif (@invite && @invite.email != current_user.email)   
      render text: "This invitation is meant for another user (You are #{current_user.email})"
    elsif @invite.nil?
       render text: 'Couldnt find this invite'
    end
    
  end

  def accept
    
    @invite = ChannelInvite.pending.find_by_token params[:id]
   
    if @invite
      
      @invite.on(:accept_invite ) {|i| redirect_to channel_path(i.channel) }
      @invite.accept!(current_user)
        
    end
    
  end
  
  def decline
    
    @invite = ChannelInvite.pending.find_by_token params[:id]
       
    if @invite
      
      @invite.on(:decline_invite) { |i| redirect_to channels_path, :notice => "You've declined the invitation" }
      @invite.decline!(current_user)
      
    end
     
  end

  def destroy
    
     invite = current_user.sent_channel_invites.find params[:id]
     channel = invite.channel  
     invite.destroy
     
     respond_to do |format|
         format.html {
           redirect_to channel_path(channel), :notice => "The invitation has been revoked"
         }
     end
     
       
      
    
  end
  
  
  private
  
  def invite_params

    params.require(:channel_invite).permit(:email)

  end


end
