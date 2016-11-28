class ChangeDatatypeInProjectTasks < ActiveRecord::Migration
  def change
  	change_column :project_tasks, :task_description, :text
  end
end
