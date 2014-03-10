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
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  has_many :channel_subs
  has_many :channels, :through => :channel_subs, :readonly => true
  has_many :owned_channels, :class_name => 'Channel', :foreign_key => 'owner_id', :dependent => :destroy
  has_one  :selfie, :class_name => 'Channel', :conditions => [:channel_type => Channel::CHANNEL_TYPES[:selfie]] 
  has_many :items
  belongs_to :plan
  
  after_create :create_selfie
  
  validates_presence_of :plan_id
    
  delegate :max_created_channels, :to => :plan
  
  before_validation do |user|
    user.plan_id ||= Plan.first.id
  end
  
  
  private
  
  def create_selfie
  
    c = channels.build(:title => '#selfie', :description => 'For your eyes only')
    c.channel_type = Channel::CHANNEL_TYPES[:selfie]
    c.save
    
  end
  
  
end
