class ItemSerializer < ActiveModel::Serializer
  attributes :id, :body, :current_user_emotes, :as_id, :channel_as_id, :current_user_forwardings
  
  has_one :link
  has_one :user, :serializer => UserSignatureSerializer
  has_many :emotings
  
  def current_user_emotes
    object.emotes_from(scope)
  end

  def current_user_forwardings
    object.forwardings_from(scope)
  end
  
end