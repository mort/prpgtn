# == Schema Information
#
# Table name: items
#
#  id               :integer          not null, primary key
#  channel_id       :integer
#  participant_id   :integer
#  participant_type :string(255)
#  item_token       :string(255)
#  body             :text
#  created_at       :datetime
#  updated_at       :datetime
#  item_type        :string(255)      default("url"), not null
#  link_id          :integer
#  forwarded        :boolean          default(FALSE), not null
#

class Item < ActiveRecord::Base
    
  ITEM_TYPES = %W(url)
  
  belongs_to :channel
  belongs_to :participant, polymorphic: true
  belongs_to :link
  
  has_many :forwardings, -> { order("created_at ASC") }
  has_many :emotings
  
  scope :by_human, -> {where(participant_type: 'User')}
  scope :by_roboto, -> {where(participant_type: 'Roboto')}
  scope :with_link, -> {where("link_id IS NOT NULL")}
  scope :without_link, -> {where("link_id IS NULL")}
  
  # Ensure it has a type
  before_validation do 
    self.item_type = 'url' if item_type.blank?
  end
    
  validates_presence_of :body, :channel, :participant
  validates_inclusion_of :item_type, :in => ITEM_TYPES
  validates_format_of :body, :with => URI::regexp(%w(http https)), :if => Proc.new {|item| item.item_type == 'url' }
  validates_uniqueness_of :body, scope: [:participant_id, :channel_id]

  validate do
    errors.add(:base, "No posts allowed") if channel.post_blocked? 
    errors.add(:base, "No permission to post") unless channel.post_public? || (channel.post_owner? && (user == channel.owner)) 
  end
  
  after_create :set_item_token
  after_create :process_url
  
  delegate :fetched_at, :to => :link, :prefix => true
  
  def user
    (participant_type == 'User') ? participant : nil
  end
  
  def roboto
    (participant_type == 'Roboto') ? participant : nil
  end
  
  def by_human?
    !user.nil?
  end

  def by_roboto?
    !roboto.nil?
  end
  
  
  def archive_links
    
    return unless by_human?
    
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

  def fwd(user, channel)
  
    f = forwardings.build(user: user, channel: channel, forwarded: true)
  
  end
  
  # Is this item in one of the channels of the user
  def is_for?(participant)
    
    participant.channels.map(&:id).include?(channel_id)
    
  end
  
  def emotes_from(user)
    
    emotings.where(user_id: user.id).map(&:emote_id)
  
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
