class ChangeDataTypeForActiveToBranch < ActiveRecord::Migration
  def change
  	  change_table :branches do |t|
      t.change :active, :string
    end
  end
end
