require 'httparty'
require 'json'

class Disembed
  
  SERVICES = {
             'vimeo' => {:base_uri => 'http://vimeo.com', :scheme => 'http:\/\/vimeo.com\/.*', :endpoint => '/api/oembed.json'}, 
             'flickr' => {:base_uri => 'http://flickr.com', :scheme => 'http:\/\/.*.flickr.com/.*', :endpoint => '/services/oembed/'},
             'youtube' => {:base_uri => 'http://youtube.com', :scheme => 'http:\/\/w*\.?youtube.com\/watch.*', :endpoint => '/oembed' },
             'twitter' => {:base_uri => 'https://api.twitter.com/1', :scheme => 'https:\/\/twitter.com\/#!\/.*\/status\/[0-9]*', :endpoint => '/statuses/oembed.json'  }
             }
             
  CLIENTS = {}           

  def self.has_embed?(url)
    
    found = false

    s = SERVICES.each do |service, data|  

     r = Regexp.new(data[:scheme])
       unless r.match(url).nil? 
         found = true
         break service
       end   
    end
    
    found ? s : found
    

  end
  
  
  def self.disembed(url, service = nil)

    service ||= has_embed?(url) 
    resp = do_request(service, url) if service

    resp.to_json
    
  end
  
  private
  
  def self.do_request(service, url)

    req = SERVICES[service][:base_uri] + SERVICES[service][:endpoint]
    
    puts "Req: #{req}"
    
    resp = HTTParty.get req, :query => {:url => url}
    resp.parsed_response

  end
  
end
