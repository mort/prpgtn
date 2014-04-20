class AddLatestNotificationAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :latest_notification_at, :datetime
  end
end
