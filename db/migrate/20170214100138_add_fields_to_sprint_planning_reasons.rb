class AddFieldsToSprintPlanningReasons < ActiveRecord::Migration
  def change
    add_column :sprint_planning_reasons, :sch_start, :date
    add_column :sprint_planning_reasons, :sch_end, :date
    add_column :sprint_planning_reasons, :delayed_type, :integer
  end
end
