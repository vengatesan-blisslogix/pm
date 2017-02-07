class AddProjectMasterIdToSprintPlanningReasons < ActiveRecord::Migration
  def change
    add_column :sprint_planning_reasons, :project_master_id, :integer
  end
end
