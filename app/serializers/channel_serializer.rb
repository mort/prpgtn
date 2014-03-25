class ChannelSerializer < ActiveModel::Serializer
  attributes :id, :title
  
  has_many :viewport_items, :root => :items
  
end
