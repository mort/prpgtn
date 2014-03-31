# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  plan_id                :integer
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  display_name           :string(255)
#  settings               :string(4096)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  context 'a creator' do
    
    setup do
    end
    
    should 'not be able to create more channels than allowed' do
      @channel = FactoryGirl.create(:channel)
      
      creator = @channel.creator
      
      ch = creator.created_channels.create(:title => 'Foo', :description => 'Foo')
      
      assert_equal ch.valid?, false  
      assert ch.errors.has_key?(:max_users) 
      
    end
  
  
  end

end
