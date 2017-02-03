class CreateProjectTaskReasons < ActiveRecord::Migration
  def change
    create_table :project_task_reasons do |t|
      t.integer :project_task_id
      t.text :date_reason
      t.text :hour_reason
      t.integer :created_by

      t.timestamps null: false
    end
  end
end
