class ActivityPublisher
  
  include Sidekiq::Worker
  

  def perform(act_id)
    
    begin
      
      @act_id = act_id
      act = Activity.find @act_id
      content = act.content

      publish_for(content[:to], content, 'to')
      publish_for(content[:cc], content, 'cc') unless content[:cc].nil?
      
      act.touch(:streamed_at)

    rescue ActiveRecord::RecordNotFound
      puts 'Activity not found'  
    end
  
  end
  
  private
  
  def conn
    @redis ||= Redis.new
  end
  
  def publish_for(recipients, content, notification_type)
  
    recipients.each do |recipient|  
      
      # Redis 
      conn.publish recipient, content.as_json 
    
      # AR
      user_id = recipient.split(':').last.to_i
      
      if user_id.is_a?(Integer)
        
        u = User.find(user_id)
        u.activity_notifications.create(activity_id: @act_id, notification_type: notification_type) 
        u.touch(:latest_notification_at)

      end
      
    end
    
  end
  
  
end