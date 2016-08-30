class AddTvsExperienceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tvs_experience, :float
  end
end
