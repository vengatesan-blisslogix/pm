class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mobile_no, :string
    add_column :users, :office_phone, :string
    add_column :users, :home_phone, :string
    add_column :users, :profile_photo, :string
    add_column :users, :active, :string
    add_column :users, :prior_experience, :integer
    add_column :users, :doj, :date
    add_column :users, :dob, :date
    add_column :users, :team_id, :integer
    add_column :users, :last_name, :string
    add_column :users, :created_by_user, :string
    add_column :users, :reporting_to, :string

  end
end

