class RemoveLinkFetchedAtFromItems < ActiveRecord::Migration
  def up
    remove_column :items, :link_fetched_at
  end

  def down
    add_column :items, :link_fetched_at, :timestamp
  end
end
