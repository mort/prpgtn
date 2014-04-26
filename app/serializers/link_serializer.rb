class LinkSerializer < ActiveModel::Serializer
  attributes :id, :og_title, :og_type, :og_image, :og_url, :og_description, :image
  
  def image
    object.as_image
  end
  
end