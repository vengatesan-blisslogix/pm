class CreateAssigns < ActiveRecord::Migration
  def change
    create_table :assigns do |t|
      t.integer :taskboard_id
      t.integer :assigned_user_id

      t.timestamps null: false
    end
  end
end
