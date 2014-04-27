class ActivityListener
  
  def item_link_fetched_successful(item)
    
    content = item.as_activity
    verb = content[:verb]
    
   Activity.create!(verb: verb, channel_id: item.channel_id, participant_id: item.participant_id, participant_type: item.participant_type, content: content)
          
 end
  
  
  def create_emoting_successful(emoting)
    
    content = emoting.as_activity
    verb = content[:verb]
    
   Activity.create!(verb: verb, channel_id: emoting.item.channel_id, participant_id: emoting.user_id, participant_type: 'User', content: content)
          
  end
  
  def join_channel(sub)
  
    content = sub.as_activity('join')
    verb = content[:verb]
    
  Activity.create!(verb: verb, channel_id: sub.channel_id, participant_id: sub.participant_id, participant_type: sub.participant_type, content: content)
          
  end
  
  
  def leave_channel(sub)
  
    content = sub.as_activity('leave')
    verb = content[:verb]
    
    Activity.create!(verb: verb, channel_id: sub.channel_id, participant_id: sub.participant_id, participant_type: sub.participant_type, content: content)
          
  end
  
  def send_invite(invite)
    
    content = invite.as_activity('invite')
    verb = content[:verb]
    
    Activity.create!(verb: verb, channel_id: invite.channel_id, participant_id: invite.sender_id, participant_type: invite.sender.class.to_s, content: content)
     
  end
  
  def accept_invite(invite)

    content = invite.as_activity('accept')
    verb = content[:verb]
    
    Activity.create!(verb: verb, channel_id: invite.channel_id, participant_id: invite.recipient_id, participant_type: invite.recipient.class.to_s, content: content, for_user_stream: false)
         
  end
  
  def decline_invite(invite)

    content = invite.as_activity('reject')
    verb = content[:verb]
    
   Activity.create!(verb: verb, channel_id: invite.channel_id, participant_id: invite.recipient_id, participant_type: invite.recipient.class.to_s, content: content)
          
  end
  
  def cancel_invite(invite)
    
    content = invite.as_activity('cancel')
    verb = content[:verb]
    
    Activity.create!(verb: verb, channel_id: invite.channel_id, participant_id: invite.sender_id, participant_type: invite.sender.class.to_s, content: content)

  end
  

end