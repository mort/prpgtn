# == Schema Information
#
# Table name: link_stats
#
#  id                  :integer          not null, primary key
#  link_id             :integer
#  item_count          :integer
#  jump_count          :integer
#  kept_count          :integer
#  fwd_count           :integer
#  twitter_share_count :integer
#  fb_share_count      :integer
#  email_share_count   :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class LinkStats < ActiveRecord::Base
  
  belongs_to :link
  
end
