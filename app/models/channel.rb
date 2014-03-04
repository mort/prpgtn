# == Schema Information
#
# Table name: channels
#
#  id          :integer          not null, primary key
#  owner_id  :integer
#  title       :string(255)      not null
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Channel < ActiveRecord::Base
  
  CHANNEL_TYPES = [:standard => 1, :selfie => 2, :popular => 3]
  
  attr_accessible :title, :description
  
  belongs_to :owner, :class_name => 'User'
  has_many :items
  
  has_many :channel_subs
  has_many :users, :through => :channel_subs, :uniq => true

  validates_presence_of :title, :description, :owner_id

  validates_inclusion_of :channel_type, :in => CHANNEL_TYPES.values

  after_create :subscribe_owner
    
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
    
end


