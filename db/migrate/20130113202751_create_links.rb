class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|

      t.string :uri
      t.string :mime_type
      t.string :og_title
      t.string :og_type
      t.string :og_image
      t.string :og_url
      t.text :og_description
      t.string :fetch_method
      t.boolean :has_embed
      t.text :oembed_response
      
      t.datetime :fetched_at

      t.timestamps
    end
  end
end
