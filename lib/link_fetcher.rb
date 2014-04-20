require 'opengraph'
require 'pismo'
require 'open_uri_unsafe_redirections'

class LinkFetcher

  def self.fetch(m)
        
    data = begin
      OGFetcher.fetch(m)
    rescue OGFail
      PismoFetcher.fetch(m)
    rescue PismoFail
      {:og_url => m, :og_title => nil, :og_description => nil, :fetch_method => nil}
    end
     
    puts "... fetched data for #{m}: #{data}"
    data.merge!(:fetched_at => Time.now)
    
  end
  
end


class OGFetcher
  
  def self.fetch(url)
    begin
      doc = OpenGraph.fetch(url)
      raise OGFail unless doc
      {:og_url => doc.url, :og_type => doc.type, :og_image => doc.image, :og_title => doc.title, :og_description => doc.description, :fetch_method => :og}
    rescue URI::InvalidURIError
      {:og_url => url, :fetch_method => :bad_uri_rescue, :bad_uri_warning => true}
    end
  end
  
end

class PismoFetcher

  def self.fetch(url)
    doc = Pismo::Document.new(url)
    raise PismoFail unless doc
    {:og_url => url, :og_title => doc.title, :og_image => nil, :og_description => doc.lede, :fetch_method => :pismo}
  end

end


class OGFail < StandardError;end  
class PismoFail < StandardError;end