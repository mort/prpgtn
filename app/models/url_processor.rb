require 'link_fetcher'

class UrlProcessor
  @queue = :url_processor #this class variable will be used as queue name in resque, so you can fill in different name
  
  def self.perform(item_id)
    
    item = Item.find item_id
    u = normalize(item.body)
    
    c = Link.count(:conditions => {:uri => u})
      
    if c < 1
    
      puts "Count #{c}. Procesando."
    
      data = LinkFetcher.fetch(u)
      data.merge!(:uri => u, :fetched_at => Time.now)
    
      puts data
    
      link = Link.create(data)
      fa = Time.now

    elsif c == 1
      
      link = Link.where(["uri = ?", u]).first
      fa = nil
      
    end
    
    item.update_attributes({:link_id => link.id, :link_fetched_at => fa})
    
    
  end
  
  
  def disembed(item)
    if serv = Disembed.has_embed?(t)
      d = Disembed.disembed(t, serv)
      item.update_attributes(:has_embed => true, :oembed_response => d)
    end
  end
  
  
  def self.normalize(body)
    u = PostRank::URI.extract(body).first
    u = PostRank::URI.clean(u)
    # u = PostRank::URI.normalize(u)
    
    PostRank::URI.unescape(u)
    
    
  end


end