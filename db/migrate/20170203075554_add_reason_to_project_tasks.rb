class AddReasonToProjectTasks < ActiveRecord::Migration
  def change
    add_column :project_tasks, :reason, :text
  end
end
