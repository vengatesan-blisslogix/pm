class RenameTaskStatusMasterToProjectTasks < ActiveRecord::Migration
  def change
    rename_column :project_tasks, :task_status_master_id, :project_board_id
  end
end
