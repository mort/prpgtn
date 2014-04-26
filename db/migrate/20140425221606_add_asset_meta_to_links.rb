class AddAssetMetaToLinks < ActiveRecord::Migration
  def change
    add_column :links, :asset_meta, :text
  end
end
