class ChannelSerializer < ActiveModel::Serializer
  attributes :id, :title, :as_id
  
  has_many :viewport_items, :root => :items
  has_many :emotes
  #has_many :users
  #has_many :robotos
    
end
