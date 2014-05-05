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
#  created_at   :datetime
#  updated_at   :datetime
#

class ChannelInvite < ActiveRecord::Base
  
  include Wisper::Publisher
  
  STATUSES = {:declined => 0, :pending => 1, :accepted => 2, :expired => 3}
  
  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
  belongs_to :channel
  
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates_uniqueness_of :email, scope: [:channel_id, :status], message: 'Already invited to this channel', on: :create
    
  validates_presence_of :sender, :email, :channel
  
  validate do 

    errors.add(:base, 'No invites allowed') unless channel.standard?
    errors.add(:base, 'Can\'t invite yourself') if sender.email == email
    
  end
  
  STATUSES.each do |k,v|
    scope k, -> { where('status = ?', v) }
  end
  
  after_create :set_token
  
  def commit
    
    subscribe(ActivityListener.new)    
    publish(:send_invite, self)  
    save!
  
  end
  
  
  def cancel
    
    subscribe(ActivityListener.new)    
    publish(:cancel_invite, self)
    destroy
    
  end
  
  def decline!(rcp)!
    
    raise "Ooops" if rcp == sender
    recipient ||= rcp

    subscribe(ActivityListener.new)    
    publish(:decline_invite, self)  
    
    update_attributes!(:status => STATUSES[:declined], :declined_at => Time.now, :recipient_id => recipient.id)
  
  end

  def accept!(rcp)!
    
    raise "Ooops" if rcp == sender
    recipient ||= rcp
    
    subscribe(ActivityListener.new)    
    publish(:accept_invite, self) 
    
    channel.subscribe(recipient)
    update_attributes!(:status => STATUSES[:accepted], :accepted_at => Time.now, :recipient_id => recipient.id)
    
    
  end

  def expire!
    update_attributes!(:status => STATUSES[:expired], :expired_at => Time.now)
  end
  
  def as_object_fields
    %w(id objectType)
  end
  
  def as_object(options = {})
    
    o = {}
    
    only = options.delete(:only)
    except = options.delete(:except)
        
    f = if only && only.is_a?(Array)  
      as_object_fields & only
    elsif except && except.is_a?(Array)  
      as_object_fields - except
    else
      as_object_fields
    end
        
    puts f.inspect    
        
    f.each { |_f| o[_f] = self.send("as_#{_f.underscore}") }
        
    o
        
  end
  
  
  def as_id
    "urn:peach:channel_invites:#{id}"
  end
  
  def as_object_type
    'invite'
  end
  
  def as_activity(v = 'invite')
    
    actor = case v
    when 'invite', 'cancel'
      sender
    when 'accept', 'reject'
      recipient
    end
    
    to = case v
    when 'invite'
      recipient 
    when 'accept', 'reject', 'cancel'
      sender
    end
    
    
    data = {
      actor: actor.as_object,
      object: as_object,
      verb: v,
      target: channel.as_object,
      published: Time.now.to_datetime.rfc3339
    }
    
    data.merge!(to: [to.as_id]) if to
    
    data
    
  end 
  
  
  
  private 

  def generate_token
    (created_at.to_i + id).to_s(36)
  end
  
  def set_token
    update_attribute :token, generate_token
  end
  
  
end
