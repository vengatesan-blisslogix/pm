class AddFieldsToReleasePlanningReasons < ActiveRecord::Migration
  def change
    add_column :release_planning_reasons, :sch_start, :date
    add_column :release_planning_reasons, :sch_end, :date
    add_column :release_planning_reasons, :delayed_type, :integer
  end
end
