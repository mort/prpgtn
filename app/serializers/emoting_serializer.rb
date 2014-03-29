class EmotingSerializer < ActiveModel::Serializer
  attributes :id, :emote_id, :user_id
end