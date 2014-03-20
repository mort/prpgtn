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
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  plan_id                :integer
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :async 

  
  has_many :channel_subs
  has_many :channels, :through => :channel_subs, :readonly => true
  has_many :own_channels, :class_name => 'Channel', :foreign_key => 'owner_id', :dependent => :destroy
  has_one  :selfie, :class_name => 'Channel', :foreign_key => 'owner_id', :conditions => {:channel_type => Channel::CHANNEL_TYPES[:selfie]}, :dependent => :destroy
  has_many :items
  has_many :archived_links 
  has_many :links, :through => :archived_links 
  has_many :sent_channel_invites, :class_name => 'ChannelInvite', :foreign_key => 'sender_id'
  has_many :received_channel_invites, :class_name => 'ChannelInvite', :foreign_key => 'recipient_id'
  
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
  
  belongs_to :plan
  
  
  before_validation :set_name
  after_create :create_selfie
  
  validates_presence_of :plan_id, :display_name
    
  delegate :max_created_channels, :to => :plan
  
  before_validation do |user|
    user.plan_id ||= Plan.first.id
  end
  
  def owns?(channel)
    id == channel.owner_id
  end

  
  def channel_sub_for(channel_id)
    channel_subs.find_by_channel_id(channel_id)
  end
  
  def make_selfie
    return if selfie
    create_selfie
  end
  
  private
  
  def set_name
    display_name = email.split('@')[0]
  end
  
  def create_selfie
  
    c = own_channels.build(:title => '#selfie', :description => 'For your eyes only')
    c.post_permissions = Channel::POST_PERMISSIONS[:owner]
    c.channel_type = Channel::CHANNEL_TYPES[:selfie]
    c.save
    
  end
  
  
end
