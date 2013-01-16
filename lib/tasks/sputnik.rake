#response = HTTParty.get('http://search.twitter.com/search.json?q=http&rpp=100&include_entities=true&result_type=mixed')
#response['results'].each {|r| r['entities']['urls'].each {|u| i = Item.new; i.user_id = i.channel_id = 1; i.body = u['expanded_url']; i.save }  }


task "sputnik:twitter_feed", [:q] => :environment do |t, args|
  
  args.with_defaults(:q => "http")
  
  puts "Buscando #{args.q}"
  
  url = "http://search.twitter.com/search.json?q=#{args.q}&rpp=100&include_entities=true&result_type=mixed"

  puts url

  response = HTTParty.get(url)
  
  response['results'].each do |r| 
    r['entities']['urls'].each do |u| 
      i = Item.new
      i.user_id = i.channel_id = 1
      i.body = u['expanded_url']
      puts i.attributes
      i.save!   
    end  
  end

end