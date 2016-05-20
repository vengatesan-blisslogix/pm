class CreateTaskboards < ActiveRecord::Migration
  def change
    create_table :taskboards do |t|
      t.integer :task_master_id
      t.string :status
      t.boolean :new, :default => true
      t.boolean :in_progress, :default => false
      t.boolean :development_completed, :default => false
      t.boolean :qa, :default => false
      t.boolean :completed, :default => false
      t.boolean :hold, :default => false
      t.string :description
      t.integer :est_time
      t.integer :project_master_id
      t.integer :sprint_planning_id

      t.timestamps null: false
    end
  end
end
