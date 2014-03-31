# == Schema Information
#
# Table name: plans
#
#  id                     :integer          not null, primary key
#  title                  :string(255)
#  description            :string(255)
#  max_created_channels   :integer
#  max_users_in_channel   :integer
#  monthly_price          :integer
#  monthly_price_currency :string(255)
#  channels_counter       :integer
#  created_at             :datetime
#  updated_at             :datetime
#

class Plan < ActiveRecord::Base
  
  has_many :channels

  validates_presence_of :title, :max_created_channels, :max_users_in_channel, :monthly_price, :monthly_price_currency
  
end
