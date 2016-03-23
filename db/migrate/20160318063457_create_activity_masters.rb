class CreateActivityMasters < ActiveRecord::Migration
  def change
    create_table :activity_masters do |t|
      t.string :activity_Name
      t.string :active

      t.timestamps null: false
    end
  end
end
