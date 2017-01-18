class AddHoursToSprintPlannings < ActiveRecord::Migration
  def change
  	add_column :sprint_plannings, :planned_hours, :float
    add_column :sprint_plannings, :actual_hours, :float
  end
end
