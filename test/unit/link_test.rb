# == Schema Information
#
# Table name: links
#
#  id              :integer          not null, primary key
#  uri             :string(255)
#  content_type    :string(255)
#  og_title        :string(255)
#  og_type         :string(255)
#  og_image        :string(255)
#  og_url          :string(255)
#  og_description  :text
#  fetch_method    :string(255)
#  has_embed       :boolean
#  oembed_response :text
#  fetched_at      :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  bad_uri_warning :boolean          default(FALSE), not null
#

require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
