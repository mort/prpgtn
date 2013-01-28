class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|

      t.string :title
      t.string :description
      t.integer :max_created_channels
      t.integer :max_users_in_channel
      t.integer :monthly_price
      t.string  :monthly_price_currency
      t.integer :channels_counter
      t.timestamps
    end
  end
end
