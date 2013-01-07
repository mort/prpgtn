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
  # test "the truth" do
  #   assert true
  # end
end
