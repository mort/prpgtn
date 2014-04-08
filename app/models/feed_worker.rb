class FeedWorker
  
  include Sidekiq::Worker
  sidekiq_options :queue => :default
  sidekiq_options :retry => 5
  
  
  def perform(feed_id)
    self.class.fetch_from_id feed_id
  end
  
  def self.discover(uri)
    Feedbag.find uri
  end
    
  def self.fetch_by_id(feed_id)
    
    feed = Feed.find feed_id
            
    fetch_by_uri feed.uri if feed
      
  end
  
  def self.fetch_by_uri(uri)
    
    data = fetch_and_parse uri
                      
    build_params(data)
    
  end  
  
  private
  
  def self.fetch_and_parse(uri)
     Feedjira::Feed.fetch_and_parse uri
  end
  
  def self.build_params(data)
    
    params = {}
    
    %w(title description language etag last_modified entries).each do |k|
      
      k = k.to_sym  
      params[k] = data.send(k) if data.respond_to?(k)
    
    end  
    
    params[:entries].each { |e| e.summary = e.content = '' }
    
    
    params
    
  end
  
end