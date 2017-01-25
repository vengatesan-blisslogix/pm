class AddSprintStatusIdToReleasePlannings < ActiveRecord::Migration
  def change
    add_column :release_plannings, :sprint_status_id, :integer
  end
end
