class AddSettingsToUser < ActiveRecord::Migration
  def change
    add_column :users, :settings, :string, :limit => 4096
  end
end
