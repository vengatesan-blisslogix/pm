class CreateReleasePlanningReasons < ActiveRecord::Migration
  def change
    create_table :release_planning_reasons do |t|
      t.integer :release_planning_id
      t.text :date_reason
      t.text :hour_reason
      t.integer :created_by

      t.timestamps null: false
    end
  end
end
