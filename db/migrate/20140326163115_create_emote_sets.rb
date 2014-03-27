class CreateEmoteSets < ActiveRecord::Migration
  def change
    create_table :emote_sets do |t|
      t.string :title
      t.string :keyword
      t.integer :status, :null => false, :default => 1
      t.timestamps
    end
  end
end
