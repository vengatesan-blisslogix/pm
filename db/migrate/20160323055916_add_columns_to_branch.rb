class AddColumnsToBranch < ActiveRecord::Migration
  def change
  	 add_column :branches, :active, :integer
  	 add_column :branches, :user_id, :integer

  end
end
