require 'link_fetcher'

class UrlProcessor
  @queue = :url_processor #this class variable will be used as queue name in resque, so you can fill in different name
  
  def self.perform(item_id)
    
    item = Item.find item_id
    
    u = normalize(item.body)    

    # Hit the cache first
    link = Link.where(["uri = ?", u]).first || fetch(u)
            
    item.update_attribute(:link_id, link.id)
    
  end
  
  def self.fetch(u)
    # Fetch link data and create the link
    data = LinkFetcher.fetch(u).merge!(:uri => u)          
    Link.create!(data)
  end
  
  
  def self.disembed(u)
    
    #TODO Support short urls for youtu.be etc 
    
    r = {:has_embed => false, :oembed_response => nil}
    serv_name = Disembed.has_embed?(u)
    
    return unless serv_name
    
    d = Disembed.disembed(u, serv_name)
    {:has_embed => true, :oembed_response => d}
  
  end
  
  
  def self.normalize(body)
    u = PostRank::URI.extract(body).first
    u = PostRank::URI.clean(u)
    # u = PostRank::URI.normalize(u)
    
    PostRank::URI.unescape(u)
    
    
  end


end