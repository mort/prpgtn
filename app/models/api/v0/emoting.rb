class Api::V0::Emoting < ActiveRecord::Base
  
  validates_presence_of :emote, :channel, :user
  
  
  
  
end
