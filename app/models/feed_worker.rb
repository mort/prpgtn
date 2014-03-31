class FeedWorker
  
  include Sidekiq::Worker
  sidekiq_options :queue => :default
  sidekiq_options :retry => 5
  
  
  def perform(feed_id)
    
    self.class.fetch_entries(feed_id)
  
  end
  
  
  def self.fetch_data(feed_id)
  
    feed = Feed.find feed_id
    
    if feed
    
      data = fetch_and_parse feed.uri
              
      params = build_data_params(data)
      
      params.merge(last_modified: data.last_modified.to_time) if data.respond_to?(:last_modified)
                
      feed.update_attributes(params)
        
    end
    
  end
  
  def self.fetch_entries(feed_id, options = {})
    
    feed = Feed.find feed_id
    
    params = {}
    fetch_data = options.delete(:fetch_data)
    
    if feed
      
      data = fetch_and_parse feed.uri
      
      params = build_data_params(data) if fetch_data
      
      feed.update_attributes params.merge!(entries: data.entries, etag: data.etag, last_modified: data.last_modified.to_time)
      
      params
      
    end
    
    
  end
    
  
  private
  
  def self.fetch_and_parse(uri)
     Feedjira::Feed.fetch_and_parse uri
  end
  
  def self.build_data_params(data)
    
    params = {}
    
    %w(title description language etag).each do |k|
      
      k = k.to_sym  
      params[k] = data.send(k) if data.respond_to?(k)
    
    end  
    
    params
    
  end
  
end