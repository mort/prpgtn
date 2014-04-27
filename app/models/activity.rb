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
  
  before_create :set_for_user_stream
  after_create :process
  
  scope :for_user_stream, -> { where(for_user_stream: true) }
  scope :not_for_user_stream, -> { where(for_user_stream: false) }
  
  def signature
    [content[:actor]['objectType'], verb, content[:object]['objectType']].join(':')
  end
  
  def as_id
    "urn:peach:activities:#{id}"
  end
  
  def content
    read_attribute(:content).merge(as_id: as_id)
  end
  
  private
  
  def set_for_user_stream
    self.for_user_stream = false if self.content[:to].nil?
    nil
  end
  
  def process
    ActivityPublisher.perform_async(self.id) if self.for_user_stream
  end

  
end
