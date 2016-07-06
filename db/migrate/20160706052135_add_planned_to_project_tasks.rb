class AddPlannedToProjectTasks < ActiveRecord::Migration
  def change
    add_column :project_tasks, :planned, :float
    add_column :project_tasks, :actual, :float
  end
end
