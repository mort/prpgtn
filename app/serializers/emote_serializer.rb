class EmoteSerializer < ActiveModel::Serializer
  attributes :id, :emote_set_id, :content
end