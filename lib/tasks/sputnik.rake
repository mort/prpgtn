#response = HTTParty.get('http://search.twitter.com/search.json?q=http&rpp=100&include_entities=true&result_type=mixed')
#response['results'].each {|r| r['entities']['urls'].each {|u| i = Item.new; i.user_id = i.channel_id = 1; i.body = u['expanded_url']; i.save }  }


task "sputnik:twitter_seed" => :environment do
  
  response = HTTParty.get('http://search.twitter.com/search.json?q=http&rpp=100&include_entities=true&result_type=mixed')
  response['results'].each {|r| r['entities']['urls'].each {|u| i = Item.new; i.user_id = i.channel_id = 1; i.body = u['expanded_url']; i.save }  }

end