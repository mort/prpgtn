class ItemSerializer < ActiveModel::Serializer

  attributes :id, :body, :current_user_emotes, :as_id
  
  has_one :link
  has_one :user, :serializer => UserSignatureSerializer
  has_many :emotings
  
  def current_user_emotes
    object.emotes_from(scope)
  end

end