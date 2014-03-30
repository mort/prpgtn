class CreateChannelSubs < ActiveRecord::Migration
  def change
    create_table :channel_subs do |t|
   
      t.references :channel
      t.references :participant, polymorphic: true
      t.timestamps
   
    end
  end
end
