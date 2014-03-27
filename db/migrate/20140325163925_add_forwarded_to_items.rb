class AddForwardedToItems < ActiveRecord::Migration
  def change
    
    add_column :items, :forwarded, :boolean, :default => false, :null => false
    
    
  end
end
