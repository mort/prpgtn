FactoryGirl.define do
  
  factory :user, aliases: [:owner] do 
    sequence(:email) {|n| "email#{n}@prpgtn.com" }        
    password               "password"
    password_confirmation  "password"
    display_name           "mort"
  end

  factory :channel do 
    sequence(:title) {|n| "channel#{n}" }        
    description       "Foo"
    owner  
  end
  
  factory :item do
    channel
    user
    body 'http://google.com'
    item_type 'url'
  end
  
  factory :plan do    
    title 'Free!'
    description 'Share away!'
    max_created_channels '1'
    max_users_in_channel '5'
    monthly_price '0'
    monthly_price_currency '$'
  end
  
  factory :forwarding do
    item
    user
    channel
  end
  
  factory :channel_sub do 
    channel
    user
  end
  
end
