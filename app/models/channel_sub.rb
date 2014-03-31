# == Schema Information
#
# Table name: channel_subs
#
#  id               :integer          not null, primary key
#  channel_id       :integer
#  participant_id   :integer
#  participant_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class ChannelSub < ActiveRecord::Base
  
  belongs_to :participant, polymorphic: true 
  belongs_to :channel
  
  validates_presence_of :participant_id, :channel_id
  
  validates :participant_id, :uniqueness => {:scope => [:channel_id, :participant_type], :message => 'Only one subscription per participant and channel'}  
  
  # validate do
  #   errors[:base] << "Channel is full. Make room! Make room!" unless (channel.users.count < channel.max_users)
  # end
  
  
end
