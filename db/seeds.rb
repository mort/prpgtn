# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



Plan.create([:title => 'Free', :description => 'Share away!', :max_users_in_channel => 5, :max_created_channels => 1, :monthly_price => '0', :monthly_price_currency => '$'], :without_protection => true)

User.create([:email => 'manuel.gonzalez.noriega@gmail.com', :password => '123456'])
User.create([:email => 'manuel.gonzalez.noriega+a@gmail.com', :password => '123456'])
User.create([:email => 'manuel.gonzalez.noriega+b@gmail.com', :password => '123456'])
User.create([:email => 'manuel.gonzalez.noriega+c@gmail.com', :password => '123456'])


Admin.create([:email => 'manuel.gonzalez.noriega@gmail.com', :password => '123456'])

Channel.create([{:title => 'Wadus', :description => 'Fuel the wadus!', :owner_id => User.first.id }], :without_protection => true)