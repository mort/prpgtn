class ChannelInvite < ActiveRecord::Base
  # attr_accessible :title, :body
  
  STATUSES = {:declined => 0, :pending => 1, :accepted => 2, :expired => 3}
  
  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
  belongs_to :channel
  
  attr_accessible :email
  
  validates_presence_of :sender_id, :email
  
  validate do 
    
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
