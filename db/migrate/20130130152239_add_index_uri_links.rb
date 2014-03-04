class AddIndexUriLinks < ActiveRecord::Migration
  def up
    add_index :links, :uri
  end

  def down
    remove_index :links, :uri
  end
end
