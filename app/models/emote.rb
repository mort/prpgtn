class Emote < ActiveRecord::Base
  
  validates_presence_of :emote_set_id, :content
  
  validates_uniqueness_of :content, scope: [:emote_set_id]
  
end
