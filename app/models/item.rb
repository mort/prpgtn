# == Schema Information
#
# Table name: items
#
#  id         :integer          not null, primary key
#  channel_id :integer
#  user_id    :integer
#  item_token :string(255)
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  item_type  :string(255)
#

class Item < ActiveRecord::Base
  attr_accessible :body
  
  ITEM_TYPES = %W(url emoji)
  
  belongs_to :channel
  belongs_to :user
  
  # Ensure it has a type
  before_validation do 
    self.item_type = 'url' if item_type.blank?
  end
  
  validates_presence_of :body, :channel_id, :user_id
  validates_inclusion_of :item_type, :in => ITEM_TYPES
  validates_format_of :body, :with => URI::regexp(%w(http https)), :if => Proc.new {|item| item.item_type == 'url' }
  
  after_create :set_item_token
  
  # 
  # def to_param
  #   item_token
  # end

  private 

  def generate_item_token
    (created_at.to_i + id).to_s(36)
  end
  
  def set_item_token
    update_attribute :item_token, generate_item_token
  end
  
  
end
