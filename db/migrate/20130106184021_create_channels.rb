class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      
      t.references :owner
      t.string :title, :null => false
      t.string :description
      t.integer :channel_type, :null => false, :default => 1

      t.timestamps
    end
  end
end
