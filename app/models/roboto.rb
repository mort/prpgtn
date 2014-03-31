# == Schema Information
#
# Table name: robotos
#
#  id                :integer          not null, primary key
#  roboto_request_id :integer
#  maker_id          :integer
#  feed_id           :integer
#  name              :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class Roboto < ActiveRecord::Base
  
  belongs_to :roboto_request
  belongs_to :maker, class_name: 'User'
  belongs_to :feed
  
  has_many :items, as: :participant
  
  has_many :channel_subs, as: :participant
  has_many :channels, -> { readonly }, :through => :channel_subs
  
  validates_presence_of :name, :maker, :roboto_request, :feed
  
  before_validation :set_name
  
  delegate :uri, :title, :description, :language, :entries, to: :feed, prefix: true
  
  def self.find_rand
    
    Roboto.find_by_sql "SELECT robotos.* FROM robotos WHERE SUBSTRING(UNIX_TIMESTAMP(robotos.created_at),-1) = FLOOR(0 + (RAND() * 9))"
  
  end
  

  
  def channel_sub_for(channel_id)
    channel_subs.where(channel_id: channel_id).first
  end

  
  def publish_latest_entry_to_all_channels
    
    channels.each do |c| 
      publish_entry_to_channel(feed.latest_entry, c.id) unless feed.latest_entry.nil?
    end
    
  end
  
  def publish_latest_entry_to_channel(channel_id)
    
    publish_entry_to_channel(feed.latest_entry, channel_id) unless feed.latest_entry.nil?
  
  end
  
  
  def publish_entry_to_all_channels(entry)
    
    channels.each { |c| publish_entry_to_channel(entry, c.id) }
  
  end
  
  def publish_entry_to_channel(entry, channel_id)
    # Entry has to respond to Atom entry methods
    
    item = self.items.build(body: entry.url, channel_id: channel_id)
    
    if !item.save
    
      puts 'Duplicate. Skipping' if (item.errors[:body] == 'has already been taken')
    
    end
    
    
  end
  
  def publish_all_entries_to_channel(channel_id)
    
    feed_entries.each { |e| publish_entry_to_channel(e, channel_id) } if feed_entries
    
  end
  
  def bootup
        
    entries =  if feed_entries.nil?
      
      params = FeedWorker.fetch_entries(feed.id, fetch_data: true)
      params[:entries]
    else
      feed_entries
    end
    
    
    publish_latest_entry_to_channel self.channels.first.id if entries
    
  end
  
  def fetch_and_publish
  end

  private

  def set_name

    self.name = [Forgery::Basic.color, Forgery::Address.street_name.split(" ").first, rand(100)].join("-").downcase

  end
  
 
  
end
