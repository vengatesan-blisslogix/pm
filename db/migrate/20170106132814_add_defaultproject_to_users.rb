class AddDefaultprojectToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_project_id, :integer
  end
end
