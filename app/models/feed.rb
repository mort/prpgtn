# == Schema Information
#
# Table name: feeds
#
#  id         :integer          not null, primary key
#  roboto_id  :integer
#  uri        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Feed < ActiveRecord::Base

  has_many :roboto

  validates_presence_of :uri
  validates_uniqueness_of :uri
  
  after_create :first_fetch
  
  private
  
  def first_fetch
    
    FeedWorker.first_fetch(self.id)
    
  end
  
end
