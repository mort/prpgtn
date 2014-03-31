# == Schema Information
#
# Table name: archived_links
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  link_id      :integer
#  archive_type :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class ArchivedLinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
