# == Schema Information
#
# Table name: activities
#
#  id               :integer          not null, primary key
#  participant_id   :integer
#  participant_type :string(255)
#  channel_id       :integer
#  verb             :string(255)
#  content          :text
#  for_user_stream  :boolean          default(TRUE)
#  streamed_at      :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

class Activity < ActiveRecord::Base
  
  serialize :content, Hash
  
  validates :channel_id, :participant_id, :participant_type, :verb, :content, presence: true
  
  belongs_to :participant, polymorphic: true
  belongs_to :channel
  
  after_create :process
  
  def signature
    [content[:actor]['objectType'], verb, content[:object]['objectType']].join(':')
  end
  
  private
  
  def process
    ActivityPublisher.perform_async(self.id)
  end

  
end
