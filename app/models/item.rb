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
  
  include Wisper::Publisher
  
  #default_scope { where("link_id IS NOT NULL").order('created_at DESC') }
    
  ITEM_TYPES = %W(url)
  
  belongs_to :channel
  belongs_to :participant, polymorphic: true
  belongs_to :link
  
  has_many :forwardings, -> { order("created_at ASC") },  dependent: :destroy
  has_many :emotings, dependent: :destroy
  
  scope :by_human, -> {where(participant_type: 'User')}
  scope :by_roboto, -> {where(participant_type: 'Roboto')}
  scope :with_link, -> {where("link_id IS NOT NULL")}
  scope :without_link, -> { where("link_id IS NULL")}
  scope :forwarded, -> {where(forwarded: true)}
  
  delegate :asset, to: :link
  
  # Ensure it has a type
  before_validation do 
    self.item_type = 'url' if item_type.blank?
  end
    
  validates_presence_of :body, :channel, :participant
  validates_inclusion_of :item_type, :in => ITEM_TYPES
  validates_format_of :body, :with => URI::regexp(%w(http https)), :if => Proc.new {|item| item.item_type == 'url' }
  validates_uniqueness_of :body, scope: [:participant_id, :participant_type, :channel_id]

  validate do
    errors.add(:base, "No posts allowed") if channel.post_blocked? 
    errors.add(:base, "No permission to post") unless channel.post_public? || (channel.post_owner? && (user == channel.owner)) 
  end
  
  after_create :set_item_token
  after_create :process_url
  
  delegate :fetched_at, :prefix => true, :to => :link
  delegate :og_title, :og_url, :og_image, :og_description, :og_type, :as_image, :to => :link
  
  def commit(_attrs)
    
    assign_attributes(_attrs) if _attrs.present?
    
    if valid?
      save!
      publish(:create_item_successful, self)
    else
      publish(:create_item_failed, self)
    end
    
  end
  
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
    user.emotings.where(user_id: user.id).map(&:emote_id)
  end

  def forwardings_from(user)
    forwardings.where(user_id: user.id).map(&:channel_id)
  end

  def as_object_fields
    %w(objectType id url displayName targetUrl content image)
  end
  
  def as_object(options = {})
    
    o = {}
    
    only = options.delete(:only)
    except = options.delete(:except)
        
    f = if only && only.is_a?(Array)  
      as_object_fields & only
    elsif except && except.is_a?(Array)  
      as_object_fields - except
    else
      as_object_fields
    end
        
    puts f.inspect    
        
    f.each { |_f| o[_f] = self.send("as_#{_f.underscore}") }
        
    o
        
  end
  

  
  def as_object_type
    'bookmark'
  end
  
  def as_id
    "urn:peach:items:#{id}"
  end
  
  def as_url
    Rails.application.routes.url_helpers.jump_channel_item_url(self.channel, self, { :host => "localhost:3000" })
  end
  
  def as_display_name
    og_title
  end
  
  def as_target_url
    og_url
  end
  
  def as_content
    og_description
  end
  
  def as_activity
    
    {
      actor: participant.as_object,
      object: as_object,
      target: channel.as_object,
      to: channel.humans.collect(&:as_id),
      verb: 'post',
      published: Time.now.to_datetime.rfc3339
    }

  end
  
  # Needed for serialization purposes
  
  def channel_as_id
    channel.as_id
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
