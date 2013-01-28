class AddPlanAttributesToChannelsUsers < ActiveRecord::Migration
  def change
    add_column :users, :plan_id, :integer
    add_column :channels, :max_users, :integer
  end
end
