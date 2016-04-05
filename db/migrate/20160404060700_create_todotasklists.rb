class CreateTodotasklists < ActiveRecord::Migration
  def change
    create_table :todotasklists do |t|
      t.string :task_name
      t.integer :created_by_user
      t.integer :closed_by_user
      t.integer :status
      t.integer :remainder
      t.integer :archive      
      t.timestamps null: false
    end
  end
end
