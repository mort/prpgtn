class CreateEmotes < ActiveRecord::Migration
  def change
    create_table :emotes do |t|
      t.references :emote_set
      t.string :content
      t.timestamps
    end
  end
end
