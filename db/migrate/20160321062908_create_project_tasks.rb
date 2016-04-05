class CreateProjectTasks < ActiveRecord::Migration
  def change
    create_table :project_tasks do |t|
      t.string :task_name
      t.string :task_description
      t.string :active
      t.integer :priority
      t.datetime :planned_duration
      t.datetime :actual_duration
      t.integer :project_master_id

      t.timestamps null: false
    end
  end
end
