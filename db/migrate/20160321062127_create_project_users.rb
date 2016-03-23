class CreateProjectUsers < ActiveRecord::Migration
  def change
    create_table :project_users do |t|
      t.date :assigned_date
      t.date :relived_date
      t.string :active
      t.float :utilization
      t.string :is_billable
      t.integer :project_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
