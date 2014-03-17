class AddPostPermissionsToChannels < ActiveRecord::Migration
  def change
    
    add_column :channels, :post_permissions, :integer, :null => false, :default => 1
    
  end
end
