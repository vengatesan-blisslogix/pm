class CreateLogtimes < ActiveRecord::Migration
  def change
    create_table :logtimes do |t|
      t.date :date
      t.time :start_time
      t.time :end_time
      t.integer :taskboard_id
      t.integer :project_master_id
      t.integer :sprint_planning_id
      t.integer :task_master_id

      
      t.timestamps null: false
    end
  end
end
