class ItemSerializer < ActiveModel::Serializer
  attributes :id, :body
  has_one :link
  has_one :user, :serializer => UserSignatureSerializer
end