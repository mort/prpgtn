# == Schema Information
#
# Table name: channels
#
#  id           :integer          not null, primary key
#  owner_id     :integer
#  title        :string(255)      not null
#  description  :string(255)
#  channel_type :integer          default(1), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  max_users    :integer
#  is_deletable :boolean          default(TRUE), not null
#

class Channel < ActiveRecord::Base
  
  CHANNEL_TYPES = {:standard => 1, :selfie => 2, :bored => 3}
  POST_PERMISSIONS = {:editorial => 0, :all => 1, :owner => 2}  
    
  
  CHANNEL_TYPES.each do |k,v|
     scope k, where('channel_type = ?', v)
   end
    
  attr_accessible :title, :description
  
  belongs_to :owner, :class_name => 'User'
  belongs_to :plan
  
  has_many :items, :order => 'created_at DESC', :dependent => :destroy
  has_many :channel_subs, :dependent => :destroy
  has_many :channel_invites, :dependent => :destroy

  has_many :users, :through => :channel_subs, :uniq => true

  validates_presence_of :title, :owner_id
  validates_inclusion_of :channel_type, :in => CHANNEL_TYPES.values
  validates_uniqueness_of :title, :scope => [:owner_id]
  
  # validate do
  #    
  #    errors.add(:max_users, "Channels maxed out. Please, upgrade.") unless (owner.created_channels.count < owner.max_created_channels)
  #    
  #  end

  #before_validation :set_max_users
  after_create :subscribe_owner
  
  def standard?
    channel_type == CHANNEL_TYPES[:standard]
  end
  
  def selfie?
    channel_type == CHANNEL_TYPES[:selfie]
  end
  
  def owned_by?(user)
    owner_id == user.id
  end
  
  def all_can_post?
    post_permissions = POST_PERMISSIONS[:all]
  end
  
  def owner_can_post?
     post_permissions = POST_PERMISSIONS[:owner]
  end
    
  def subscribe(user)
    cs = channel_subs.build
    cs.user = user
    cs.save!
  end
  
  def unsubscribe(user)
    channel_subs.find_by_user_id(user.id).destroy
  end
  
  private
  
  def subscribe_owner
    subscribe(owner)
  end

  def set_max_users
    self.max_users = User.find(self.owner_id).plan.max_users_in_channel
  end
  
    
end
