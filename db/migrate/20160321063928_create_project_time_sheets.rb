class CreateProjectTimeSheets < ActiveRecord::Migration
  def change
    create_table :project_time_sheets do |t|
      t.date :duration_in_hours
      t.datetime :date_time
      t.string :comments
      t.string :timesheet_status
      t.integer :approved_by
      t.integer :project_id
      t.integer :task_id

      t.timestamps null: false
    end
  end
end
