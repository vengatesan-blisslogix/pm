class CreateRoleActivityMappings < ActiveRecord::Migration
  def change
    create_table :role_activity_mappings do |t|
      t.integer :role_master_id
      t.integer :activity_master_id
      t.integer :access_value
      t.integer :user_id
      t.integer :active
      
      t.timestamps null: false
    end
  end
end