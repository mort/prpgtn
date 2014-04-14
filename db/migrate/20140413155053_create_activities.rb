class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      
      t.references :participant, polymorphic: true
      t.references :channel
      t.string :verb
      t.text :content
      t.boolean :for_user_stream, default: true
      t.datetime :streamed_at
      t.timestamps

    end
  end
end
