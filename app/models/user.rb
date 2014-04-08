# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  plan_id                :integer
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  display_name           :string(255)
#  settings               :string(4096)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :async 
         
  store :settings, accessors: [ :latest_updated_channel_id ], coder: JSON
         
  has_many :channel_subs, as: :participant, :dependent => :destroy
  has_many :channels, -> { readonly }, :through => :channel_subs

  has_many :own_channels, :class_name => 'Channel', :foreign_key => 'owner_id', :dependent => :destroy
  has_one  :selfie, -> { where ["channel_type = ?", Channel::CHANNEL_TYPES[:selfie]] }, :class_name => 'Channel', :foreign_key => 'owner_id' , :dependent => :destroy
  has_many :items, as: :participant
  has_many :archived_links 
  has_many :links, :through => :archived_links 
  has_many :sent_channel_invites, :class_name => 'ChannelInvite', :foreign_key => 'sender_id'
  has_many :received_channel_invites, :class_name => 'ChannelInvite', :foreign_key => 'recipient_id'
  has_many :forwardings
  has_many :emotings
  has_many :robotos, :foreign_key => 'maker_id'
  has_many :roboto_requests
  
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
    
  before_validation(on: :create) do
    
    self.display_name = self.email.split('@')[0] unless attribute_present?('display_name')

  end
  
  after_create :create_selfie

  validates_presence_of :display_name
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  delegate :max_created_channels, :to => :plan
  
  
  def owns?(channel)
    id == channel.owner_id
  end

  
  def channel_sub_for(channel_id)
    channel_subs.where(channel_id: channel_id).first
  end
  
  def make_selfie
    return if selfie
    create_selfie
  end
  
  def fwd_item(item)
    item.fwd(self, item)
  end
  
  private

  
  def create_selfie
  
    c = own_channels.build(:title => '#selfie', :description => 'For your eyes only', :is_deletable => false)
    c.post_permissions = Channel::POST_PERMISSIONS[:owner]
    c.channel_type = Channel::CHANNEL_TYPES[:selfie]
    c.save
    
  end
  
  
end
