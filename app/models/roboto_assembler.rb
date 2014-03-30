class RobotoAssembler 
  
  attr_reader :request, :feed

  include Sidekiq::Worker
  sidekiq_options :queue => :robotos
  sidekiq_options :retry => 5


  def initialize(request)
  
    raise "Bad Request" unless request.is_a?(RobotoRequest)
  
    @request = request
    @feed = nil
    
  end
  
  def perform
    # Check uri
    # Discover feed
    # Create Feed
    # Create roboto
    # Subscribe roboto to channel
    
    begin

      feed_uris = Feedbag.find @request.uri
      
      if feed_uris.is_a?(Array)
        
        feed_uri = feed_uris.first

        feed = Feed.find_or_create_by(uri: feed_uri)
                        
        roboto = @request.user.robotos.create(roboto_request_id: @request.id, feed_id: feed.id)         
       
        @request.channel.subscribe(roboto) if roboto
        
        @request.update_attributes({processed_at: Time.now, roboto_id: roboto.id })
        
      end
      
    end
    
    
    
  end


end