class CreateRobotos < ActiveRecord::Migration
  def change
    create_table :robotos do |t|
      t.references :roboto_request
      t.references :maker
      t.references :feed
      t.string :name
      t.timestamps
    end
  end
end
