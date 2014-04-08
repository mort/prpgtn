require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  context 'discovery' do
    
      setup do
        @i = FactoryGirl.create(:feed)
        DatabaseCleaner.start
      end
      
  end    


end
