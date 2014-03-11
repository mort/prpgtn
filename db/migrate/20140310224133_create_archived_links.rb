class CreateArchivedLinks < ActiveRecord::Migration
  def change
    create_table :archived_links do |t|
      t.references :user
      t.references :link
      t.integer :archive_type
      t.timestamps
    end
  end
end
