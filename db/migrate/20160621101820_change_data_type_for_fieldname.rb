class ChangeDataTypeForFieldname < ActiveRecord::Migration
  def change
  	  change_table :project_users do |t|
      t.change :utilization, :integer
    end
  end
end
