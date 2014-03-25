class UserSerializer < ActiveModel::Serializer
  attributes :id, :display_name
  has_many   :channels, serializer: ChannelListSerializer
end