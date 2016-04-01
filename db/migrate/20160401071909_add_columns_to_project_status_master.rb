class AddColumnsToProjectStatusMaster < ActiveRecord::Migration
  def change
  	add_column :project_status_masters, :active, :integer
  	add_column :project_status_masters, :user_id, :integer
  end
end
