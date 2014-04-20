# == Schema Information
#
# Table name: roboto_requests
#
#  id             :integer          not null, primary key
#  channel_id     :integer
#  user_id        :integer
#  roboto_id      :integer
#  uri            :string(255)
#  processed_at   :datetime
#  created_at     :datetime
#  updated_at     :datetime
#  feed_id        :integer
#  process_status :integer          default(0), not null
#

class RobotoRequest < ActiveRecord::Base
  
  PROCESS_STATUSES = {pending: 0, fail: 1, ok: 2}
  
  PROCESS_STATUSES.each do |k,v| 
    scope "process_#{k}", -> { where(process_status: PROCESS_STATUSES[k]) }
  end
  
  validates_presence_of :channel, :user, :uri
  validates_format_of :uri, :with => URI::regexp(%w(http https))
  
  belongs_to :user
  belongs_to :channel
  belongs_to :roboto 
  belongs_to :feed 
  
  after_create :process
  
  def process_status_text
    PROCESS_STATUSES.invert[process_status].to_s
  end
  
  def mark_as_processed_fail(feed)
    update_attributes({processed_at: Time.now, process_status: PROCESS_STATUSES[:fail], feed_id: feed.id })
  end
  
  def mark_as_processed_ok(roboto)
    update_attributes({processed_at: Time.now,  process_status: PROCESS_STATUSES[:ok], roboto_id: roboto.id })
  end
  
  def process
    RobotoMechanic.perform_async(self.id)
  end
  
end
