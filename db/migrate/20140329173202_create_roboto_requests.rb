class CreateRobotoRequests < ActiveRecord::Migration
  def change
    create_table :roboto_requests do |t|
      t.references :channel
      t.references :user
      t.references :roboto
      t.string :uri
      t.timestamp :processed_at
      t.timestamps
    end
  end
end
