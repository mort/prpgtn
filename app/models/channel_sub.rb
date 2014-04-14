# == Schema Information
#
# Table name: channel_subs
#
#  id               :integer          not null, primary key
#  channel_id       :integer
#  participant_id   :integer
#  participant_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class ChannelSub < ActiveRecord::Base
  
  include Wisper::Publisher
  
  belongs_to :participant, polymorphic: true 
  belongs_to :channel
  
  validates_presence_of :participant_id, :channel_id
  
  validates :participant_id, :uniqueness => {:scope => [:channel_id, :participant_type], :message => 'Only one subscription per participant and channel'}  
  
  # validate do
  #   errors[:base] << "Channel is full. Make room! Make room!" unless (channel.users.count < channel.max_users)
  # end
  
  def commit
    
    subscribe(ActivityListener.new)    
    publish(:join_channel, self)  
    save!
    
  end
  
  def cancel
    
    subscribe(ActivityListener.new)    
    publish(:leave_channel, self)
    destroy
    
  end
  
  def as_object_fields
    %w(id)
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
    "urn:peach:channel_subs:#{id}"
  end
  
  def as_activity(v = 'join')
    
    {
      actor: participant.as_object,
      object: channel.as_object,
      to: channel.humans.collect(&:as_id),
      verb: v,
      published: Time.now.to_datetime.rfc3339
    }

  end  
  
  
  
end
