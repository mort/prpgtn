# == Schema Information
#
# Table name: items
#
#  id               :integer          not null, primary key
#  channel_id       :integer
#  participant_id   :integer
#  participant_type :string(255)
#  item_token       :string(255)
#  body             :text
#  created_at       :datetime
#  updated_at       :datetime
#  item_type        :string(255)      default("url"), not null
#  link_id          :integer
#  forwarded        :boolean          default(FALSE), not null
#

require 'test_helper'

class ItemTest < ActiveSupport::TestCase

  context 'an item' do
    
      setup do
        @i = FactoryGirl.create(:item)
        DatabaseCleaner.start
      end
      
      should 'have a valid factory' do
        assert @i.valid?
      end
    
      should 'have a token' do
        assert_not_nil @i.item_token
      end
      
      should 'have a type of url when none has been specified' do
        i = FactoryGirl.create(:item, :item_type => '')
        assert_equal 'url', i.item_type
      end
            
      should 'allow only valid types' do
        assert !FactoryGirl.build(:item, :item_type => 'wadus').valid?
      end
      
      should 'not accept body with no urls when type is url' do
        assert !FactoryGirl.build(:item, :item_type => 'url', :body => 'wadus').valid?
      end
      
      should 'accept body in url when type is url' do
        assert FactoryGirl.build(:item, :item_type => 'url', :body => 'http://google.com').valid?
      end
      
      
      
      teardown do
        DatabaseCleaner.clean  
      end
    
  end

end
