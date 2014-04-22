class AddAssetToLink < ActiveRecord::Migration
  def change
    add_attachment :links, :asset
  end
end
