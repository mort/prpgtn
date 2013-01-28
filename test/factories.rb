FactoryGirl.define do
  
  factory :user, aliases: [:creator] do 
    sequence(:email) {|n| "email#{n}@sputnikgo.com" }        
    password               "password"
    password_confirmation  "password"
    plan
  end

  factory :channel do 
    title             "Foo"
    description       "Foo"
    creator  
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
  
  factory :channel_sub do 
    channel
    user
  end
  
end
