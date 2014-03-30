# == Schema Information
#
# Table name: emotings
#
#  id         :integer          not null, primary key
#  item_id    :integer
#  user_id    :integer
#  emote_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Emoting < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :item
  belongs_to :emote

  validates_presence_of   :emote, :item, :user
  validates_uniqueness_of :emote_id, scope: [:item_id, :user_id]
  
  
  
end
