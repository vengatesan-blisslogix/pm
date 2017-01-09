class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.string :name
      t.date :started_on
      t.date :ended_on
      t.integer :status_id
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
