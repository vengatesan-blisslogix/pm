class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :client_name
      t.string :client_company_name
      t.string :web_address
      t.string :first_address
      t.string :second_address
      t.string :city
      t.string :state
      t.string :country
      t.string :zip_code
      t.string :region
      t.string :client_email
      t.string :mobile
      t.string :phone1
      t.string :phone2
      t.string :fax
      t.string :skypke
      t.integer :star_rating
      t.string :active
      t.string :comments
      t.string :tag
      t.string :archived
      t.integer :client_source_id

      t.timestamps null: false
    end
  end
end
