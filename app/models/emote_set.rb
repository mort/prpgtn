# == Schema Information
#
# Table name: emote_sets
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  keyword    :string(255)
#  status     :integer          default(1), not null
#  created_at :datetime
#  updated_at :datetime
#

class EmoteSet < ActiveRecord::Base
  
  STATUS = {on: 1, off: 0}
  
  
  validates_presence_of :title, :keyword, :status
  validates_uniqueness_of :title
  validates_uniqueness_of :keyword
  
  has_many :emotes
  
end
