class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name
      t.string :code

      t.timestamps null: false
    end
  end
end
