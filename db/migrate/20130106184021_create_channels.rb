class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      
      t.references :creator
      t.string :title, :null => false
      t.string :description

      t.timestamps
    end
  end
end
