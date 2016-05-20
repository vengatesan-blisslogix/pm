class CreateSprintStatuses < ActiveRecord::Migration
  def change
    create_table :sprint_statuses do |t|
      t.string :status
      t.integer :active
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
