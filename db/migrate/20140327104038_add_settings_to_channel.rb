class AddSettingsToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :settings, :string, :limit => 4096
  end
end
