class CreateActivityNotifications < ActiveRecord::Migration
  def change
    create_table :activity_notifications do |t|
      t.references :user
      t.references :activity
      t.string :notification_type
      t.timestamps
    end
  end
end
