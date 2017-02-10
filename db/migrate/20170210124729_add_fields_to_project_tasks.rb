class AddFieldsToProjectTasks < ActiveRecord::Migration
  def change
    add_column :project_tasks, :sc_start, :date
    add_column :project_tasks, :sc_end, :date
    add_column :project_tasks, :delay_type, :integer
  end
end
