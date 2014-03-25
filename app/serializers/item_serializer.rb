class ItemSerializer < ActiveModel::Serializer
  attributes :id, :body
  has_one :link
end