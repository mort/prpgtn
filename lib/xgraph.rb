module OpenGraph
  
  def self.xfetch(uri, strict = true)
    
    begin 
      response = RestClient.get(uri)
    rescue RestClient::Exception, SocketError
      false
    end

    page = parse(response.body, strict)

    [page, response.headers]

  end
end

