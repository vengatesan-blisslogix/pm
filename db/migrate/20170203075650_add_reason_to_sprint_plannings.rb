class AddReasonToSprintPlannings < ActiveRecord::Migration
  def change
    add_column :sprint_plannings, :reason, :text
  end
end
