class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.string :name
      t.string :description
      t.string :active
      t.integer :user_id
      t.string :stage

      t.timestamps null: false
    end
  end
end
