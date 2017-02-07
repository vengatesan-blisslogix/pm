class AddProjectMasterIdToProjectTaskReasons < ActiveRecord::Migration
  def change
    add_column :project_task_reasons, :project_master_id, :integer
  end
end
