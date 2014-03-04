# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Plan.create([:title => 'Free', :description => 'Share away!', :max_users_in_channel => 5, :max_created_channels => 1, :monthly_price => '0', :monthly_price_currency => '$'], :without_protection => true)

Channel.create([{:title => 'Wadus', :description => 'Fuel the wadus!', :creator_id => User.first.id }], :without_protection => true)