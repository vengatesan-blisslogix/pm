class AddTotalExperienceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total_experience, :float
  end
end
