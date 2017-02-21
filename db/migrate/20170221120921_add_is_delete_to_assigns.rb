class AddIsDeleteToAssigns < ActiveRecord::Migration
  def change
    add_column :assigns, :is_delete, :integer
  end
end
