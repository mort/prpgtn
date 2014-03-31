class AddFeedInfoToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :title, :string
    add_column :feeds, :description, :text
    add_column :feeds, :language, :string
    add_column :feeds, :entries, :text
    add_column :feeds, :latest_status, :string
    add_column :feeds, :fetched_at, :datetime
    add_column :feeds, :etag, :string
    add_column :feeds, :last_modified, :datetime
  end
end
