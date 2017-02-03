class CreateSprintPlanningReasons < ActiveRecord::Migration
  def change
    create_table :sprint_planning_reasons do |t|
      t.integer :sprint_planning_id
      t.text :date_reason
      t.text :hour_reason
      t.integer :created_by

      t.timestamps null: false
    end
  end
end
