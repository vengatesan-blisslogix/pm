class CreateTodotaskshares < ActiveRecord::Migration
  def change
    create_table :todotaskshares do |t|     
      t.integer :todotasklist_id
      t.integer :shared_by
      t.integer :shared_to
      t.timestamps null: false
    end
  end
end
