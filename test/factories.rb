FactoryGirl.define do
  
  factory :user, aliases: [:owner] do 
    sequence(:email) {|n| "email#{n}@sputnikgo.com" }        
    password               "password"
    password_confirmation  "password"
  end

  factory :channel do 
    title             "Foo"
    description       "Foo"
    owner  
  end
  
  factory :item do
    channel
    user
    body 'http://google.com'
    item_type 'url'
  end
  
end
