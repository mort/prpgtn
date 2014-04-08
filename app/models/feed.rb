# == Schema Information
#
# Table name: feeds
#
#  id              :integer          not null, primary key
#  uri             :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  title           :string(255)
#  description     :text
#  language        :string(255)
#  entries         :text
#  latest_status   :string(255)
#  fetched_at      :datetime
#  etag            :string(255)
#  last_modified   :datetime
#  admin_created   :boolean          default(FALSE), not null
#  discovered_at   :datetime
#  discovered_uris :text
#  submitted_uri   :string(255)      not null
#

class Feed < ActiveRecord::Base

  serialize :entries
  serialize :discovered_uris
  
  CREATION_STATUSES = {:pending => 0, :failed_at_discovery => 1, :failed_at_fetch => 2, :ok => 3}
  FETCH_STATUSES = {:pending => 0, :failed => 1, :ok => 2}

  has_many :robotos, dependent: :nullify
  has_many :roboto_requests

  validates :submitted_uri, uniqueness: true, presence: true
  validates :uri, uniqueness: true, allow_nil: true 
  
  before_validation :discover, on: :create  
  before_save :first_fetch, on: :create
  before_destroy :fire_robotos
  
  scope :admin_created, -> { where(admin_created: true)}

  CREATION_STATUSES.each do |k,v|
    scope "creation_#{k}", -> { where(creation_status: CREATION_STATUSES[k]) }
  end
  
  FETCH_STATUSES.each do |k,v| 
    scope "fetch_#{k}", -> { where(fetch_status: FETCH_STATUSES[k]) }
  end

  def latest_entry
    !entries.nil? ? entries.first : nil
  end
    
  def roboto
    robotos.first
  end
  
  def creation_ok?
    creation_status == CREATION_STATUSES[:ok]
  end
  
  def fetch_ok?
    fetch_status == FETCH_STATUSES[:ok]
  end
  
  def fetch
    
    data = FeedWorker.fetch_by_uri uri
    data.merge!(fetched_at: Time.now, fetch_status: FETCH_STATUSES[:ok]) if data
     
    update_attributes(data)     
    
  end
  
  private
  
  def discover

    if Feedbag.feed? submitted_uri      
       self.uri =  submitted_uri
    else
      
      uris = FeedWorker.discover submitted_uri

      if uris.any?
       
       self.uri = uris.first
       self.discovered_at = Time.now
       self.discovered_uris = uris 
        
      else
        self.creation_status = CREATION_STATUSES[:failed_discovery]    
      end
      
    end
      
  end
  
 
  def first_fetch   
        
    data = FeedWorker.fetch_by_uri uri
        
    data.merge!(fetched_at: Time.now, creation_status: CREATION_STATUSES[:ok]) if data
    
    self.attributes = self.attributes.merge data

  end

  
  def fire_robotos
    robotos.find_each { |r| r.quit }
  end
  
  
  
    
end
