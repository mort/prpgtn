# == Schema Information
#
# Table name: links
#
#  id              :integer          not null, primary key
#  uri             :string(255)
#  content_type    :string(255)
#  og_title        :string(255)
#  og_type         :string(255)
#  og_image        :string(255)
#  og_url          :string(255)
#  og_description  :text
#  fetch_method    :string(255)
#  has_embed       :boolean
#  oembed_response :text
#  fetched_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Link < ActiveRecord::Base
  
  attr_accessible :og_url, :og_title, :og_image, :og_description, :fetch_method, :uri, :fetched_at, :og_type, :has_embed, :oembed_response
  
  has_many :items
  
  validates_presence_of :uri
  validates_uniqueness_of :uri
  
  
end
