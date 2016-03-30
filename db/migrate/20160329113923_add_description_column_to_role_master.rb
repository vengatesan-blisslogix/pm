class AddDescriptionColumnToRoleMaster < ActiveRecord::Migration
  def change
    add_column :role_masters, :description, :string
  end
end
