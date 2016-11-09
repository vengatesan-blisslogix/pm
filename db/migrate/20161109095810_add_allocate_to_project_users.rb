class AddAllocateToProjectUsers < ActiveRecord::Migration
  def change
    add_column :project_users, :allocate, :integer
  end
end
