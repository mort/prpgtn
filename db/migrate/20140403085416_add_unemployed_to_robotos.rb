class AddUnemployedToRobotos < ActiveRecord::Migration
  def change
    add_column :robotos, :unemployed, :boolean, :default => false
  end
end
