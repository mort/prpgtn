class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :verb, :content, :as_id
end
