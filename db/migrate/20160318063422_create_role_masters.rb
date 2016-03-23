class CreateRoleMasters < ActiveRecord::Migration
  def change
    create_table :role_masters do |t|
      t.string :role_name
      t.string :active

      t.timestamps null: false
    end
  end
end
