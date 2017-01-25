class IsDeleteToProjectTasks < ActiveRecord::Migration
  def change 
  	add_column :project_tasks, :is_delete, :integer
  end
end
