class AddFieldsToProjectTaskReasons < ActiveRecord::Migration
  def change
    add_column :project_task_reasons, :sch_start, :date
    add_column :project_task_reasons, :sch_end, :date
    add_column :project_task_reasons, :delayed_type, :integer
  end
end
