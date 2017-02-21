class ChangeUtilizationTypeInProjectUsers < ActiveRecord::Migration
  def change
  	change_table :project_users do |t|
      t.change :utilization, :float
  	end
  end
end
