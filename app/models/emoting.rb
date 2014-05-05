# == Schema Information
#
# Table name: emotings
#
#  id         :integer          not null, primary key
#  item_id    :integer
#  user_id    :integer
#  emote_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Emoting < ActiveRecord::Base
  
  include Wisper::Publisher
  
  
  belongs_to :user
  belongs_to :item
  belongs_to :emote

  validates_presence_of :emote, :item, :user
  validates_uniqueness_of :emote_id, scope: [:item_id, :user_id]
  
 
  def commit(_attrs)
    
    assign_attributes(_attrs) if _attrs.present?
    
    if valid?

      save!
      publish(:create_emoting_successful, self)
      
    else
      publish(:create_emoting_failed, self)
    end
    
  end
  
  
  def as_object_fields
    %w(objectType id content author)
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
  
  def as_author
    user.as_object
  end
  
  def as_object_type
    'comment'
  end
  
  def as_id
    "urn:peach:emotings:#{id}"
  end
  
  def as_content
    
    emote.content
    
  end
  
  def as_activity
  
    {
      actor: user.as_object,
      object: as_object,
      target: item.channel.as_id,
      inReplyTo: item.as_id,
      published: Time.now.to_datetime.rfc3339,
      verb: 'post',
      to: [item.participant.as_id],
      cc: item.channel.humans.collect(&:as_id) - [item.participant.as_id]
    }
    
  
  end
  
end
