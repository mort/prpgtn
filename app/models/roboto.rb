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
#  unemployed        :boolean          default(FALSE)
#  admin_created     :boolean          default(FALSE), not null
#

class Roboto < ActiveRecord::Base
  
  belongs_to :roboto_request
  belongs_to :maker, class_name: 'User'
  belongs_to :feed
  
  has_many :items, as: :participant
  
  has_many :channel_subs, as: :participant
  has_many :channels, -> { readonly }, :through => :channel_subs
  
  validates_presence_of :name
  validates_presence_of :maker, :roboto_request, :feed, unless: Proc.new { |roboto| roboto.admin_created? }
  
  validates_uniqueness_of :roboto_request, allow_nil: true
  
  before_save do |r|
    r.unemployed = r.feed_id.nil? ? true : false 
    # hehe, http://apidock.com/rails/ActiveRecord/RecordNotSaved
    nil
  end
  
  before_validation :set_name, on: :create
  
  delegate :uri, :title, :description, :language, :entries, to: :feed, prefix: true, allow_nil: true
  
  scope :unemployed, -> { where(unemployed: true).order('updated_at DESC') }
    
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
            
    greet_channel(self.channels.first.id)
    publish_latest_entry_to_channel(self.channels.first.id) if feed_entries
    
  end
  
  def greet_channel(channel_id)
    
    item = self.items.build(body: my_url, channel_id: channel_id)
    item.save
    
  end
  
  def my_url
     Rails.application.routes.url_helpers.roboto_url(self, host: '0.0.0.0:3000')
  end
  
  def quit
    update_attributes(unemployed: true, feed_id: nil) 
  end
  
  def join(feed)
    update_attributes(unemployed: false, feed_id: feed.id)
  end
  
  def employed?
    !unemployed
  end
  
  def available?
    unemployed
  end
  

  private

  def set_name

    self.name = [Forgery::Basic.color, Forgery::Address.street_name.split(" ").first, rand(100)].join("-").downcase

  end
  
 
  
end
