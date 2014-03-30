# == Schema Information
#
# Table name: channels
#
#  id               :integer          not null, primary key
#  owner_id         :integer
#  title            :string(255)      not null
#  description      :string(255)
#  channel_type     :integer          default(1), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  max_users        :integer
#  is_deletable     :boolean          default(TRUE), not null
#  post_permissions :integer          default(1), not null
#  settings         :string(4096)
#

class Channel < ActiveRecord::Base
  
  store :settings, accessors: [ :emote_set_id ], coder: JSON
  
  
  CHANNEL_TYPES = {:standard => 1, :selfie => 2, :bored => 3}
  POST_PERMISSIONS = {:blocked => 0, :public => 1, :owner => 2}  
  
  VIEWPORT_SIZE = 10
  
  CHANNEL_TYPES.each do |k,v|
     scope k, -> { where('channel_type = ?', v) }
   end
   
  POST_PERMISSIONS.each do |k,v|
    scope k, -> { where('post_permissions = ?', v) }
  end
      
  belongs_to :owner, :class_name => 'User'
  belongs_to :plan
  
  has_many :items, -> { order('created_at DESC') }, :dependent => :destroy
  has_many :viewport_items, -> { order('created_at DESC').limit(Channel::VIEWPORT_SIZE) }, :class_name => 'Item'
  has_many :channel_invites, :dependent => :destroy

  has_many :channel_subs, :dependent => :destroy 
  has_many :users, -> { uniq }, :through => :channel_subs, :source => :participant, :source_type => 'User'
  has_many :robotos, -> { uniq }, :through => :channel_subs, :source => :participant, :source_type => 'Roboto'

    
  validates_presence_of :title, :owner_id, :emote_set_id, :post_permissions
  validates_inclusion_of :channel_type, :in => CHANNEL_TYPES.values
  validates_uniqueness_of :title, :scope => [:owner_id]
  
  before_validation(on: :create) do
    
    self.emote_set_id = EmoteSet.first.id
  
  end
  
  
  # validate do
  #    
  #    errors.add(:max_users, "Channels maxed out. Please, upgrade.") unless (owner.created_channels.count < owner.max_created_channels)
  #    
  #  end

  #before_validation :set_max_users
  
  after_create :subscribe_owner 
  
  def participants
    users + robotos
  end
  
  def standard?
    channel_type == CHANNEL_TYPES[:standard]
  end
  
  def selfie?
    channel_type == CHANNEL_TYPES[:selfie]
  end
  
  def owned_by?(user)
    user.is_a?(User) && (owner_id == user.id)
  end

  def post_blocked?
    post_permissions == POST_PERMISSIONS[:blocked]
  end
  
  def post_public?
    post_permissions == POST_PERMISSIONS[:public]
  end
  
  def post_owner?
     post_permissions == POST_PERMISSIONS[:owner]
  end
  
  def emote_set
    return nil if selfie?

    begin 
      EmoteSet.find(emote_set_id) 
    rescue ActiveRecord::RecordNotFound
      e = EmoteSet.first
      emote_set_id = e.id
      self.class.delay.assign_emote_set(self.id, e.id)      
      e
    end
  end
  
  def emotes
    return [] if selfie?
    emote_set.emotes
  end
  
  def self.assign_emote_set(channel_id, emote_set_id)
    find(channel_id).update_attribute(:emote_set_id, emote_set_id)
  end
    
  def subscribe(participant)
    # Robotos can only subscribe to standard channels
    raise "No robots allowed!" if (participant.is_a?(Roboto) && !standard?)
    # Only owners can subscribe to a selfie channel
    raise "Not for you!" if selfie? && !owned_by?(participant)
    
    cs = channel_subs.build(participant_type: participant.class.to_s.downcase, participant: participant)
    cs.save!
  end
  
  def unsubscribe(participant)
    channel_subs.where({participant_id: participant.id, participant_type: participant.class.to_s.downcase}).destroy_all
  end
  
  private
  

  def subscribe_owner
    subscribe(owner)
  end

  def set_max_users
    self.max_users = User.find(self.owner_id).plan.max_users_in_channel
  end
  
    
end
