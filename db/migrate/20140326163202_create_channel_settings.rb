class CreateChannelSettings < ActiveRecord::Migration
  def change
    create_table :channel_settings do |t|
      t.references :channel
      t.string :key
      t.string :value
      t.timestamps
    end
  end
end
