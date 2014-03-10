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

require 'test_helper'

class ChannelTest < ActiveSupport::TestCase

  context 'a channel' do
    
      setup do
        @channel = FactoryGirl.create(:channel)
      end
      
      should 'have one subscriber to boot' do
        assert_equal 1, @channel.users.size
      end
    
<<<<<<< HEAD
      should 'have the owner as first subscriber' do
         assert_equal @channel.users.first, @channel.owner
       end
=======
      should 'have the creator as first subscriber' do
        assert_equal @channel.users.first, @channel.creator
      end
       
       
       
>>>>>>> b36161d0d7819f76f7a14cfb46f698ea8cfe1020
    
  end
  
  
end
