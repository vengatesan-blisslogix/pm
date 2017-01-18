class AddHoursToReleasePlannings < ActiveRecord::Migration
  def change
    add_column :release_plannings, :planned_hours, :float
    add_column :release_plannings, :actual_hours, :float
  end
end
