class RenameMimeTypeContentType < ActiveRecord::Migration
  def up
    
    rename_column :links, :mime_type, :content_type
    
  end

  def down

    rename_column :links, :content_type, :mime_type

  end

end
