class ActivityListener
  
  def item_link_fetched_successful(item)
    
    content = item.as_activity
    verb = content[:verb]
    
    a = Activity.new(verb: verb, channel_id: item.channel_id, participant_id: item.participant_id, participant_type: item.participant_type, content: content)
          
    a.save!
    
    
  end
  
  
  def create_emoting_successful(emoting)
    
    content = emoting.as_activity
    verb = content[:verb]
    
    a = Activity.new(verb: verb, channel_id: emoting.item.channel_id, participant_id: emoting.user_id, participant_type: 'User', content: content)
          
    a.save!
    
  end
  
  def join_channel(sub)
  
    content = sub.as_activity('join')
    verb = content[:verb]
    
    a = Activity.new(verb: verb, channel_id: sub.channel_id, participant_id: sub.participant_id, participant_type: sub.participant_type, content: content)
          
    a.save!
    
  
    
  end
  
  
  def leave_channel(sub)
  
    content = sub.as_activity('leave')
    verb = content[:verb]
    
    a = Activity.new(verb: verb, channel_id: sub.channel_id, participant_id: sub.participant_id, participant_type: sub.participant_type, content: content)
          
    a.save!
    
  
    
  end
  

end