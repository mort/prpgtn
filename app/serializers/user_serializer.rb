class UserSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :latest_updated_channel_id
  has_many   :channels, serializer: ChannelListSerializer
end