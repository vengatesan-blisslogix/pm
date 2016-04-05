class CreateSprintPlannings < ActiveRecord::Migration
  def change
    create_table :sprint_plannings do |t|
      t.string :active
      t.date :start_date
      t.date :end_date
      t.string :sprint_name
      t.string :sprint_desc
      t.integer :sprint_status_id
      t.integer :project_master_id
      t.integer :release_planning_id

      t.timestamps null: false
    end
  end
end
