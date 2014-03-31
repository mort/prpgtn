class AddBadUriWarnToLinks < ActiveRecord::Migration
  def change
    add_column :links, :bad_uri_warning, :boolean, default: false, null: false
  end
end
