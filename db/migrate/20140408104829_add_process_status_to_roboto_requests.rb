class AddProcessStatusToRobotoRequests < ActiveRecord::Migration
  def change
    add_column :roboto_requests, :process_status, :integer, null: false, default: 0
  end
end
