class CreateUserFavourites < ActiveRecord::Migration
  def change
    create_table :user_favourites do |t|
      t.integer :user_id
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
