# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create!([
             {:email => 'manuel.gonzalez.noriega@gmail.com', :password => '123456'},
             {:email => 'manuel.gonzalez.noriega+a@gmail.com', :password => '123456'},
             {:email => 'manuel.gonzalez.noriega+b@gmail.com', :password => '123456'},
             {:email => 'manuel.gonzalez.noriega+c@gmail.com', :password => '123456'}      
          ])

EmoteSet.create([title: 'Buzzfeed', keyword: 'buzzfeed', status: 1])


Emote.create([
             {content: '<3', emote_set_id: EmoteSet.first.id}, 
             {content: '</3', emote_set_id: EmoteSet.first.id}, 
             {content: 'LOL', emote_set_id: EmoteSet.first.id}, 
             {content: 'OLD', emote_set_id: EmoteSet.first.id}, 
             {content: 'OMG', emote_set_id: EmoteSet.first.id}, 
             {content: 'WTF', emote_set_id: EmoteSet.first.id}, 
             {content: 'CUTE', emote_set_id: EmoteSet.first.id}, 
             {content: 'WIN', emote_set_id: EmoteSet.first.id}, 
             {content: 'FAIL', emote_set_id: EmoteSet.first.id}, 
             {content: 'TRASHY', emote_set_id: EmoteSet.first.id}, 
             {content: 'EW', emote_set_id: EmoteSet.first.id},
             {content: 'YAAASS', emote_set_id: EmoteSet.first.id}
             ])


Admin.create([:email => 'manuel.gonzalez.noriega@gmail.com', :password => '123456'])

Channel.create({:title => 'Wadus', :description => 'Fuel the wadus!', :owner_id => User.first.id })

# Channel.channel_settings.create()