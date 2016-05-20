class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.integer :project_master_id
      t.integer :project_task_id
      t.integer :user_id
      t.date :task_date
      t.float :task_time

      t.timestamps null: false
    end
  end
end
