class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|

      t.references :channel
      t.references :participant, polymorphic: true
      t.string :item_token
      t.text :body
      t.timestamps
      
    end
  end
end
