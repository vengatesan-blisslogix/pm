class CreateBusinessUnits < ActiveRecord::Migration
  def change
    create_table :business_units do |t|
      t.string :name
      t.string :description
      t.string :active
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
