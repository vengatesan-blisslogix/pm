class CreateTechnologyMasters < ActiveRecord::Migration
  def change
    create_table :technology_masters do |t|
      t.string :technology
      t.string :active

      t.timestamps null: false
    end
  end
end
