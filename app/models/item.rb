# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  channel_id   :integer
#  user_id      :integer
#  base36_token :string(255)
#  body         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Item < ActiveRecord::Base
  attr_accessible :body
  
  belongs_to :channel
  belongs_to :user
  
  validates_presence_of :body, :channel_id, :user_id
  
  after_create :set_item_token
  
  def to_param
    item_token
  end

  private 

  def generate_item_token
    (created_at.to_i + id).to_s(36)
  end
  
  def set_item_token
    update_attribute :item_token, generate_item_token
  end
  
end
