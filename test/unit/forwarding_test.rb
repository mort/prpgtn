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

require 'test_helper'

class ForwardingTest < ActiveSupport::TestCase

  context 'forwarding an item' do
    
    setup do
      @f = create(:forwarding)
      DatabaseCleaner.start
    end
    
    should 'not accept forwarding to a channel of which the user is not part' do

      u = create(:user)
      c = create(:channel)  
      assert !FactoryGirl.create(:forwarding, :channel => c, :user => u).valid?
    
    end
    
  end


end
