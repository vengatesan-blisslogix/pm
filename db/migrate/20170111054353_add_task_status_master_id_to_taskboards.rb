class AddTaskStatusMasterIdToTaskboards < ActiveRecord::Migration
  def change
    add_column :taskboards, :task_status_master_id, :integer
  end
end
