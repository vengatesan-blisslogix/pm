class AddColumnsToTaskStatusMasters < ActiveRecord::Migration
  def change
    add_column :task_status_masters, :description, :string
  end
end
