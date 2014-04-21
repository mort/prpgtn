class UserSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :latest_updated_channel_id, :as_id, :as_image
  has_many   :channels, serializer: ChannelSerializer
end