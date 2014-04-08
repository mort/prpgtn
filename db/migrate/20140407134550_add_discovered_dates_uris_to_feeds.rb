class AddDiscoveredDatesUrisToFeeds < ActiveRecord::Migration
  def change
    
    add_column :feeds, :discovered_at, :datetime
    add_column :feeds, :discovered_uris, :text
    
  end
end
