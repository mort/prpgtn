# == Schema Information
#
# Table name: activity_notifications
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  activity_id       :integer
#  notification_type :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class ActivityNotification < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :activity
  
  validates_uniqueness_of :activity, scope: :user
  
end
