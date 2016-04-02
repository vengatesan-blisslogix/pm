class CreateProjectTypes < ActiveRecord::Migration
  def change
    create_table :project_types do |t|
      t.string :project_name
      t.integer :active
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
