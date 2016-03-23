class CreateClientSources < ActiveRecord::Migration
  def change
    create_table :client_sources do |t|
      t.string :source_name
      t.string :description
      t.string :active

      t.timestamps null: false
    end
  end
end
