# == Schema Information
#
# Table name: robotos
#
#  id                :integer          not null, primary key
#  roboto_request_id :integer
#  maker_id          :integer
#  name              :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class Roboto < ActiveRecord::Base
  
  belongs_to :roboto_request
  belongs_to :maker, class_name: 'User'
  belongs_to :feed
  
  has_many :channel_subs, as: :participant
  has_many :channels, -> { readonly }, :through => :channel_subs
  
  validates_presence_of :name, :maker, :roboto_request, :feed
  
  before_validation :set_name


  def channel_sub_for(channel_id)
    channel_subs.where(channel_id: channel_id).first
  end

  private

  def set_name

    self.name = [Forgery::Basic.color, Forgery::Address.street_name.split(" ").first, rand(100)].join("-").downcase

  end
  
end
