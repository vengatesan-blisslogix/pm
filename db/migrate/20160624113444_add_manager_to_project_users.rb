class AddManagerToProjectUsers < ActiveRecord::Migration
  def change
    add_column :project_users, :manager, :integer
  end
end
