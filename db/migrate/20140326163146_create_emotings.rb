class CreateEmotings < ActiveRecord::Migration
  def change
    create_table :emotings do |t|
      t.references :item
      t.references :user
      t.references :emote
      t.timestamps
    end
  end
end
