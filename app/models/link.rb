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
#  created_at      :datetime
#  updated_at      :datetime
#  bad_uri_warning :boolean          default(FALSE), not null
#

class Link < ActiveRecord::Base
  
  #attr_accessible :og_url, :og_title, :og_image, :og_description, :fetch_method, :uri, :fetched_at, :og_type, :has_embed, :oembed_response
  
  has_many :items
  has_many :archived_links
  has_many :users, :through => :archived_links
  
  validates :uri, presence: true, uniqueness: true
  
  scope :with_image, -> { where('og_image IS NOT NULL')}
   
  has_attached_file :asset, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :asset, :content_type => /\Aimage\/.*\Z/
  
  #has_one :link_stats
  #after_create :create_stats
  
  def fetch_og?
    fetch_method == 'og'
  end
  
  def archive_for(user, options)
    
    l = archived_links.build
    l.user_id = user.id
    l.archive_type = options[:as]
    
    if l.save
    
    else
    
      puts l.errors.as_json
    
    end
    
    #TODO Add to list of channels in archived link if link was already present
    
  end
  
  def as_image
    
    {
      url: asset.url(:medium),
      mediaType: asset.content_type,
      width: asset.width(:medium),
      height: asset.height(:medium)
    } if asset
      
  end
  
  #after_create :disembed
  
  private
  
  # def disembed
  #   embed_attrs = UrlProcessor.disembed(uri)
  #   update_attributes!(embed_attrs)
  # end 
  
  # def create_stats
  #   
  #   create_link_stats! :item_count => 1
  #   
  # end
  
  
end
