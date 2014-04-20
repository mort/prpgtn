class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :verb, :content
end
