class CreateUserTechnologies < ActiveRecord::Migration
  def change
    create_table :user_technologies do |t|
      t.integer :technology_master_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
