FactoryGirl.define do
  
  factory :user, aliases: [:creator] do 
    sequence(:email) {|n| "email#{n}@sputnikgo.com" }        
    password               "password"
    password_confirmation  "password"
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
  
end
