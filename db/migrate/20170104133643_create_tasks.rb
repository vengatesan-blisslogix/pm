class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.float :p_hours
      t.float :c_hours
      t.date :started_on
      t.date :ended_on
      t.integer :assignee_id
      t.integer :assigner_id
      t.integer :task_priority_id
      t.integer :task_board_id
      t.integer :project_id
      t.integer :sprint_id
      t.integer :release_id

      t.timestamps null: false
    end
  end
end
