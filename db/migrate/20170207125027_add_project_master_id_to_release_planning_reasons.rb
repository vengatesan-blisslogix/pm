class AddProjectMasterIdToReleasePlanningReasons < ActiveRecord::Migration
  def change
    add_column :release_planning_reasons, :project_master_id, :integer
  end
end
