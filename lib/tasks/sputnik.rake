task "sputnik:twitter_feed", [:q, :limit] => :environment do |t, args|
  
  args.with_defaults(:q => "http", :limit => '100')
    
  url = "http://search.twitter.com/search.json?q=#{args.q}&rpp=#{args.limit}&include_entities=true&result_type=mixed"

  puts url

  response = HTTParty.get(url)
  
  user = User.first
  c = Channel.first
  
  raise "Twitter has left the building #{response.inspect}" if (response['errors'] || response['error'])
  
  response['results'].each do |r| 
    r['entities']['urls'].each do |u| 
      i = Item.new
      i.user_id = user.id
      i.channel_id = c.id
      i.body = u['expanded_url']
      i.save!   
      puts "MSG: #{i.body}"
    end  
  end

end