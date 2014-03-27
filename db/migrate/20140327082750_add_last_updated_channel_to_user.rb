class AddLastUpdatedChannelToUser < ActiveRecord::Migration
  def change
    add_column :users, :latest_updated_channel_id, :integer
  end
end
