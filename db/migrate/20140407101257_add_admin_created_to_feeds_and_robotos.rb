class AddAdminCreatedToFeedsAndRobotos < ActiveRecord::Migration
  def change
    
    add_column :robotos, :admin_created, :boolean, :null => false, :default => false
    add_column :feeds, :admin_created, :boolean, :null => false, :default => false

  end
end
