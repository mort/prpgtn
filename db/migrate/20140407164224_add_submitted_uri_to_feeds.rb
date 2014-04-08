class AddSubmittedUriToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :submitted_uri, :string, :null => false
  end
end
