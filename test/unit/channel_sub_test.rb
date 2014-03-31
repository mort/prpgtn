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
