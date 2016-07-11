class AddColumnsToProjectStatusMasters < ActiveRecord::Migration
  def change
    add_column :project_status_masters, :description, :string
  end
end
