class CreateTodotaskmappings < ActiveRecord::Migration
  def change
    create_table :todotaskmappings do |t|
      t.integer :todotasklist_id
      t.integer :created_by_user
      t.integer :closed_by_user
      t.timestamps null: false
    end
  end
end
