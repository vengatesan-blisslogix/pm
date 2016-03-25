class AddParentIdColumnToActivityMaster < ActiveRecord::Migration
  def change
    add_column :activity_masters, :parent_id, :integer
  end
end
