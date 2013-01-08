# == Schema Information
#
# Table name: channel_subs
#
#  id         :integer          not null, primary key
#  channel_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ChannelSub < ActiveRecord::Base
  # attr_accessible :title, :body
  
  belongs_to :user
  belongs_to :channel
  
  validates_presence_of :user_id, :channel_id
  
  validates :user_id, :uniqueness => {:scope => :channel_id, :message => 'Only one subscription per user and channel'}  
  
end