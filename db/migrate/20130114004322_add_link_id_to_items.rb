class AddLinkIdToItems < ActiveRecord::Migration
  def change
    
    add_column :items, :link_id, :integer
    add_column :items, :link_fetched_at, :datetime
    
  end
end
