class AddColumnToProjectUsers < ActiveRecord::Migration
  def change
    add_column :project_users, :default_project, :integer
  end
end
