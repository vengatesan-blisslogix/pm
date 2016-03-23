class CreateProjectTaskMappings < ActiveRecord::Migration
  def change
    create_table :project_task_mappings do |t|
      t.date :assign_date
      t.date :completed_date
      t.string :planned_duration
      t.string :actual_duration
      t.integer :assigned_by
      t.string :active
      t.string :priority
      t.integer :sprint_planning_id
      t.integer :task_status_id
      t.integer :project_task_id
      t.integer :project_id
      t.integer :release_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
