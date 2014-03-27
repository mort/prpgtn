class CreateForwardings < ActiveRecord::Migration
  def change
    create_table :forwardings do |t|
      t.references :item
      t.references :channel
      t.references :user
      t.references :original_fwd
      t.timestamps
    end
  end
end
