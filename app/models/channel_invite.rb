# == Schema Information
#
# Table name: channel_invites
#
#  id           :integer          not null, primary key
#  channel_id   :integer
#  sender_id    :integer
#  recipient_id :integer
#  email        :string(255)
#  token        :string(255)
#  status       :integer          default(1), not null
#  accepted_at  :datetime
#  declined_at  :datetime
#  expired_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ChannelInvite < ActiveRecord::Base
  # attr_accessible :title, :body
  
  STATUSES = {:declined => 0, :pending => 1, :accepted => 2, :expired => 3}
  
  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
  belongs_to :channel
  
  attr_accessible :email, :status, :accepted_at, :recipient_id, :declined_at
  
  validates_presence_of :sender_id, :email, :channel_id
  validates_uniqueness_of :email, :scope => [:channel_id], :conditions => ["status = ?", STATUSES[:pending]], :message => 'Already invited to this channel', :on => :create
  
  validate do 

    errors.add(:base, 'No invites allowed') unless channel.standard?
    errors.add(:base, 'Can\'t invite yourself') if sender.email == email
    
  end
  
  STATUSES.each do |k,v|
    scope k, where('status = ?', v)
  end
  
  after_create :set_token
  
  def decline!(recipient)!
    raise "Ooops" if recipient == sender
    update_attributes!(:status => STATUSES[:declined], :declined_at => Time.now, :recipient_id => recipient.id)
  end

  def accept!(recipient)!
    raise "Ooops" if recipient == sender
    update_attributes!(:status => STATUSES[:accepted], :accepted_at => Time.now, :recipient_id => recipient.id)
  end

  def expire!
    update_attributes!(:status => STATUSES[:expired], :expired_at => Time.now)
  end
  
  private 

  def generate_token
    (created_at.to_i + id).to_s(36)
  end
  
  def set_token
    update_attribute :token, generate_token
  end
  
  
end
