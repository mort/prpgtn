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

require 'test_helper'

class ChannelTest < ActiveSupport::TestCase

  context 'a channel' do
    
      setup do
        @channel = FactoryGirl.create(:channel)
      end
      
      should 'have one subscriber to boot' do
        assert_equal 1, @channel.users.size
      end
    
      should 'have the owner as first subscriber' do
         assert_equal @channel.users.first, @channel.owner
       end
    
  end
  
  
end
