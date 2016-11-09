class AddManagersToProjectMasters < ActiveRecord::Migration
  def change
    add_column :project_masters, :account_manager_id, :integer
    add_column :project_masters, :project_manager_id, :integer
  end
end
