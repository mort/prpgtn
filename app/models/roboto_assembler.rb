class RobotoAssembler 
  
  attr_reader :request, :feed

  include Sidekiq::Worker
  sidekiq_options :queue => :default
  sidekiq_options :retry => 5


  def initialize(request)
  
    raise "Bad Request" unless request.is_a?(RobotoRequest)
  
    @request = request
    
  end
  
  def feed_uris
    
    Feedbag.find @request.uri
    
  end
  
  def make_feed(uri)
    
    Feed.find_or_create_by(uri: uri)
  
  end
  
  def make_roboto(feed, request)
  
    request.user.robotos.create(roboto_request_id: request.id, feed_id: feed.id) 
    
  end
  
  
  def perform
  
      
    begin

      fu = feed_uris
      
      if fu.any?
        
        feed = make_feed(fu.first)
                        
        roboto = make_roboto(feed, @request)        
       
        if roboto
          
          @request.channel.subscribe(roboto) 
          @request.mark_as_processed(roboto)
          roboto.bootup
          
        end  
      
      end
      
    end
    
    
    
  end


end