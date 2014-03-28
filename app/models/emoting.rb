# == Schema Information
#
# Table name: api_v0_emotings
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


  validates_presence_of :emote, :item, :user
  validates_uniqueness_of :emote_id, scope: [:user_id, :item_id]
  
end
