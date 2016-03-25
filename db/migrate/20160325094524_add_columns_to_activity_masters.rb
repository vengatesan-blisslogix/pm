class AddColumnsToActivityMasters < ActiveRecord::Migration
  def change
    add_column :activity_masters, :href, :string
    add_column :activity_masters, :icon, :string
  end
end
