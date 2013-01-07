# == Schema Information
#
# Table name: channels
#
#  id          :integer          not null, primary key
#  creator_id  :integer
#  title       :string(255)      not null
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Channel < ActiveRecord::Base
  attr_accessible :title, :description
  
  belongs_to :creator, :class_name => 'User'
  has_many :items
  
  has_many :channel_subs
  has_many :subscribers, :class_name => 'User', :through => :channel_subs, :uniq => true

  validates_presence_of :title, :description, :creator_id

  #after_create :subscribe_creator
    
  def subscribe(user)
    cs = channel_subs.build
    cs.user = user
    cs.save!
  end
  
  def unsubscribe(user)
    channel_subs.find_by_user_id(user.id).destroy
  end
  
  private
  
  def subscribe_creator
    subscribe(creator)
  end  
    
end


