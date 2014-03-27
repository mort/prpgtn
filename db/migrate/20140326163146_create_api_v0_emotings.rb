class CreateApiV0Emotings < ActiveRecord::Migration
  def change
    create_table :api_v0_emotings do |t|
      t.references :item
      t.references :user
      t.references :emote
      t.timestamps
    end
  end
end
