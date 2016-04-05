class CreateReleasePlannings < ActiveRecord::Migration
  def change
    create_table :release_plannings do |t|
      t.string :release_name
      t.date :start_date
      t.date :end_date
      t.string :comments
      t.string :active
      t.string :release_notes
      t.integer :approved
      t.integer :approved_by_user_id
      t.string :qa_approved
      t.integer :qa_approved_by_user_id
      t.datetime :qa_approved_date_time
      t.integer :user_id
      t.integer :project_master_id

      t.timestamps null: false
    end
  end
end
