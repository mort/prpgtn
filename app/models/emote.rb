# == Schema Information
#
# Table name: emotes
#
#  id           :integer          not null, primary key
#  emote_set_id :integer
#  content      :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Emote < ActiveRecord::Base
  
  validates_presence_of :emote_set_id, :content
  validates_uniqueness_of :content, scope: [:emote_set_id]
  
  belongs_to :emote_set
  
end
