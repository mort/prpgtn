class EmoteSet < ActiveRecord::Base
  
  STATUS = {on: 1, off: 0}
  
  
  validates_presence_of :title, :keyword, :status
  validates_uniqueness_of :title
  validates_uniqueness_of :keyword
  
end
