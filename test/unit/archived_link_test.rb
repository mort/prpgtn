# == Schema Information
#
# Table name: archived_links
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  link_id      :integer
#  archive_type :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class ArchivedLinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
