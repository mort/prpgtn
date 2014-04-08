class AddStatusesToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :creation_status, :integer, null: false, default: 0
    add_column :feeds, :fetch_status, :integer
  end
end
