class FeedWorker
  
  include Sidekiq::Worker
  sidekiq_options :queue => :feeds
  sidekiq_options :retry => 5
  
  
  def self.first_fetch(feed_id)
  
    feed = Feed.find feed_if
    
    if feed
    
      data = Feedjira::Feed.fetch_and_parse feed.uri
    
        
    
    
    end
    
  
  end
  
end