# == Schema Information
#
# Table name: feeds
#
#  id            :integer          not null, primary key
#  uri           :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  title         :string(255)
#  description   :text
#  language      :string(255)
#  entries       :text
#  latest_status :string(255)
#  fetched_at    :datetime
#  etag          :string(255)
#  last_modified :datetime
#

class Feed < ActiveRecord::Base

  serialize :entries

  has_many :roboto

  validates_presence_of :uri
  validates_uniqueness_of :uri
  
  
  def latest_entry
    
    !entries.nil? ? entries.first : nil
  
  end
    
end
