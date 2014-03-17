class CreateLinkStats < ActiveRecord::Migration
  def change
    create_table :link_stats do |t|
      t.references :link
      t.integer :item_count
      t.integer :jump_count
      t.integer :kept_count
      t.integer :fwd_count
      t.integer :twitter_share_count
      t.integer :fb_share_count
      t.integer :email_share_count
      t.timestamps
    end
  end
end
