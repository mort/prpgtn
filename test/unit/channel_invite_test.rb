# == Schema Information
#
# Table name: channel_invites
#
#  id           :integer          not null, primary key
#  channel_id   :integer
#  sender_id    :integer
#  recipient_id :integer
#  email        :string(255)
#  token        :string(255)
#  status       :integer          default(1), not null
#  accepted_at  :datetime
#  declined_at  :datetime
#  expired_at   :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class ChannelInviteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
