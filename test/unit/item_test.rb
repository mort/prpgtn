# == Schema Information
#
# Table name: items
#
#  id         :integer          not null, primary key
#  channel_id :integer
#  user_id    :integer
#  item_token :string(255)
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ItemTest < ActiveSupport::TestCase

  context 'an item' do
    
      setup do
        DatabaseCleaner.start
      end
    
      should 'have a token' do
        
        @i = FactoryGirl.create(:item)
        assert_not_nil @i.item_token
        
      end
      
      teardown do
        DatabaseCleaner.clean  
      end
    
  end

end
