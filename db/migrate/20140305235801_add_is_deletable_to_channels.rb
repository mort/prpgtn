class AddIsDeletableToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :is_deletable, :boolean, :null => false, :default => true
  end
end
