# == Schema Information
#
# Table name: archived_links
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  link_id      :integer
#  archive_type :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ArchivedLink < ActiveRecord::Base
  # attr_accessible :title, :body
  
  ARCHIVE_TYPES = {:by => 1, :for => 2, :kept => 3}
  
  belongs_to :user
  belongs_to :link
  
  validates_presence_of :archive_type
  validates_uniqueness_of :link_id, :scope => [:user_id, :archive_type]
  
  ARCHIVE_TYPES.each do |k,v| 
    scope k, where('archive_type = ?', v)
  end
  
end
