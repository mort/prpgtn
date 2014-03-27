# == Schema Information
#
# Table name: forwardings
#
#  id              :integer          not null, primary key
#  item_id         :integer
#  channel_id      :integer
#  user_id         :integer
#  original_fwd_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Forwarding < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :item
  belongs_to :channel
  belongs_to :original_fwd, :class_name => 'Item'
  
  validates_presence_of :item, :channel, :user
  
  validate do
    errors.add(:base, "Can't fwd to this channel") unless user.channels.map(&:id).include?(channel_id) && (item.channel_id != channel_id)
  end
  
  after_create :create_item
  
  
  private
  
  
  def async_create_item
    
    FwdWorker.perform_async(id)
    
  end  
  
  def create_item
  
    f = Forwarding.find(id)
    original_fwd_id = f.item.forwardings.first.id if f.item.forwarded
    Item.create!(body: f.item.body, channel: f.channel, user: f.user, forwarded: true)
    
  end
  
end
