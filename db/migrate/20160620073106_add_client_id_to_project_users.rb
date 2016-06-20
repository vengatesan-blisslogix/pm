class AddClientIdToProjectUsers < ActiveRecord::Migration
  def change
    add_column :project_users, :client_id, :integer
  end
end
