class AddUserIdToTechnologyMasters < ActiveRecord::Migration
  def change
    add_column :technology_masters, :user_id, :integer
  end
end
