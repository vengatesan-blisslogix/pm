class ChangeDataTypeForPriorExperience < ActiveRecord::Migration
  def change
  	 change_table :users do |t|
     t.change :prior_experience, :float
 	end
  end
end
