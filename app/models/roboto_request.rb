# == Schema Information
#
# Table name: roboto_requests
#
#  id           :integer          not null, primary key
#  channel_id   :integer
#  user_id      :integer
#  roboto_id    :integer
#  uri          :string(255)
#  processed_at :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

class RobotoRequest < ActiveRecord::Base
  
  validates_presence_of :channel, :user, :uri
  validates_format_of :uri, :with => URI::regexp(%w(http https))
  
  belongs_to :user
  belongs_to :channel
  
  
end
