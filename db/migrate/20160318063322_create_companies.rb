class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :company_name
      t.string :display_name
      t.string :web_address
      t.string :first_address
      t.string :second_address
      t.string :city
      t.string :state
      t.string :country
      t.string :zip_code
      t.string :region
      t.string :email
      t.string :mobile
      t.string :phone1
      t.string :phone2
      t.string :fax
      t.string :skype
      t.integer :star_rating
      t.string :active
      t.string :comments
      t.string :company_logo

      t.timestamps null: false
    end
  end
end
