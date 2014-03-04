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

require 'test_helper'

class ChannelSubTest < ActiveSupport::TestCase

  context 'a channel sub' do
    
    setup do
      @channel = FactoryGirl.create(:channel)
      @channel.users.expects(:count).returns(@channel.max_users)
    end
    
    should 'not happen if the channel is full' do
      
      FactoryGirl.create(:channel_sub, :channel => @channel)
    
    end
  
  
  end

end
