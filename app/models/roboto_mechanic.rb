class RobotoMechanic
  
  attr_reader :request, :feed

  include Sidekiq::Worker
  sidekiq_options :queue => :default
  sidekiq_options :retry => 5

  def self.next
    
    ra = RobotoRequest.pending.first
    raise "No pending requests" unless ra
    
    self.new(ra) 
    
  end
  
    
  def find_or_make_roboto(feed, request)
      
    roboto = Roboto.unemployed.first || request.user.robotos.create(roboto_request_id: request.id, feed_id: feed.id, unemployed: false) 
    roboto.join(feed) if roboto.unemployed?
    roboto    
  end
  
  
  def perform(request_id)
                    
    request = RobotoRequest.process_pending.find request_id                
            
    begin
      
      feed = Feed.find_or_create_by(submitted_uri: request.uri) 
        
      if (feed.creation_ok? || feed.fetch_ok?)
        
        roboto = feed.robotos.any? ? feed.robotos.first : find_or_make_roboto(feed, request)

        request.channel.subscribe(roboto) 
        request.mark_as_processed_ok(roboto)
        roboto.bootup
      
      else
        
        request.mark_as_processed_fail(feed)
        
      end  

    end  
 
  end


end