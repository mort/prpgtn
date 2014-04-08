class AddFeedIdToRobotoRequests < ActiveRecord::Migration
  def change
    add_column :roboto_requests, :feed_id, :integer
  end
end
