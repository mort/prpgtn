require 'link_fetcher'

class UrlProcessor
  include Sidekiq::Worker
  sidekiq_options :queue => :url_processor
  sidekiq_options :retry => 5
    
  def perform(item_id)
    
    link_created = false
    
    item = Item.find item_id
    
    if item
    
      u = normalize(item.body)    
    
      puts "_______ Working with #{u}"

      # Hit the cache first
      existing_link = Link.where(["uri = ?", u]).first
    
      link = if existing_link
        puts "... Existing link #{existing_link.id} from #{existing_link.created_at.to_s}"
        existing_link
      
      else 
    
        link_attrs = embed_attrs = nil
       
        puts "... Fetching link"
        link_attrs = fetch(u)
    
        puts "... Disembedding link"
        embed_attrs = embedly_disembed(u)
  
        attrs = link_attrs.merge!(embed_attrs)

        puts "Creating link #{attrs}"
        Link.create!(attrs)
        
      end
    
        
      item.update_column(:link_id, link.id)
      
      if item.by_human?
        
        item.archive_links
        item.user.update_attribute(:latest_updated_channel_id, item.channel.id)
    
      end
    
    end
  end
  
  def fetch(u)
    # Fetch link data and create the link
    LinkFetcher.fetch(u).merge!(:uri => u)          
    #Link.create!(data)
  end
  
  def embedly_disembed(u)
    "... hitting Embedly for #{u}"
    d = Disembed.disembed(u)
    {:has_embed => true, :oembed_response => d}
    
  end
  
  
  def disembed(u)
    
    #TODO Support short urls for youtu.be etc 
    
    r = {:has_embed => false, :oembed_response => nil}
    serv_name = Disembed.has_embed?(u)
    
    return unless serv_name
    
    d = Disembed.disembed(u, serv_name)
    {:has_embed => true, :oembed_response => d}
  
  end
  
  
  def normalize(body)
    u = PostRank::URI.extract(body).first
    u = PostRank::URI.clean(u)
    # u = PostRank::URI.normalize(u)
    
    PostRank::URI.unescape(u)
    
    
  end


end