class AddRoleMasterToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :role_master, index: true, foreign_key: true
  end
end
