class RenamePriorityToProjectTasks < ActiveRecord::Migration
  def change
    rename_column :project_tasks, :priority, :priority_id
  end
end
