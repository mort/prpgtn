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
  has_many :archived_links
  has_many :users, :through => :archived_links
  
  validates_presence_of :uri
  validates_uniqueness_of :uri
  
  def fetch_og?
    fetch_method == 'og'
  end
  
  def archive_for(user, options)
    l = archived_links.build
    l.user_id = user.id
    l.archive_type = options[:as]
    l.save!
  end
  
  #after_create :disembed
  
  # private
  
  # def disembed
  #   embed_attrs = UrlProcessor.disembed(uri)
  #   update_attributes!(embed_attrs)
  # end 
  
  
  
end