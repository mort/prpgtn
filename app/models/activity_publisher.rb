class ActivityPublisher
  
  include Sidekiq::Worker
  
  def perform(act_id)
    
    begin
      
      act = Activity.find act_id
      content = act.content
            
      dest = content[:to] 
      dest =+ content[:cc] unless content[:cc].nil?
            
      Sidekiq.redis { |conn| 
        dest.each { |d| 
          puts "Publishing to #{d} -- #{content.as_json}"
          
          conn.publish d, content.as_json 
        } 
      }
      
      act.update_attribute(:streamed_at, Time.now)
      
    rescue ActiveRecord::RecordNotFound
      puts 'Activity not found'  
    end
  
  
  end
  
  
end