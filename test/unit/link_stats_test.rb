# == Schema Information
#
# Table name: link_stats
#
#  id                  :integer          not null, primary key
#  link_id             :integer
#  item_count          :integer
#  click_count         :integer
#  kept_count          :integer
#  fwd_count           :integer
#  twitter_share_count :integer
#  fb_share_count      :integer
#  email_share_count   :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'test_helper'

class LinkStatsTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
