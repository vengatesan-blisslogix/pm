class AddTaskStatusMasterToProjectTasks < ActiveRecord::Migration
  def change
    add_column :project_tasks, :task_status_master_id, :integer
  end
end
