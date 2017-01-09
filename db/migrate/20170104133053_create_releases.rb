class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.string :name
      t.datetime :released_on
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
