class Activity < ActiveRecord::Base
  
  serialize :content, Hash
  
  validates :channel_id, :participant_id, :participant_type, :verb, :content, presence: true
  
  after_create :process
  
  private
  
  def process
    ActivityPublisher.perform_async(self.id)
  end
  
  
end
