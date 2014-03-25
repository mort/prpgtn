# == Schema Information
#
# Table name: items
#
#  id         :integer          not null, primary key
#  channel_id :integer
#  user_id    :integer
#  item_token :string(255)
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  item_type  :string(255)      default("url"), not null
#  link_id    :integer
#

class Item < ActiveRecord::Base
    
  ITEM_TYPES = %W(url)
  
  belongs_to :channel
  belongs_to :user
  belongs_to :link
  
  class << self
    def with_link
      where("link_id IS NOT NULL")
    end
  end
  
  # Ensure it has a type
  before_validation do 
    self.item_type = 'url' if item_type.blank?
  end
    
  validates_presence_of :body, :channel, :user
  validates_inclusion_of :item_type, :in => ITEM_TYPES
  validates_format_of :body, :with => URI::regexp(%w(http https)), :if => Proc.new {|item| item.item_type == 'url' }

  validate do
    errors.add(:base, "No posts allowed") if channel.post_blocked? 
    errors.add(:base, "No permission to post") unless channel.post_public? || (channel.post_owner? && (user == channel.owner)) 
  end
  
  after_create :set_item_token
  after_create :process_url
  
  delegate :fetched_at, :to => :link, :prefix => true
  
  def archive_links
    
    if link
      
      link.archive_for(user, :as => ArchivedLink::ARCHIVE_TYPES[:by])
      
      r = channel.users-[user]
      r.each do |u|
        link.archive_for(u, :as => ArchivedLink::ARCHIVE_TYPES[:for])
      end if r.any? # except #selfie
      
    end

  end

  def keep_link_for(user)
    link.archive_for(user, :as => ArchivedLink::ARCHIVE_TYPES[:kept])
  end

  private 

  def generate_item_token
    (created_at.to_i + id).to_s(36)
  end
  
  def set_item_token
    update_attribute :item_token, generate_item_token
  end
  
  def process_url
    return unless item_type == 'url'
    UrlProcessor.perform_async(id)
  end
  
end
