class ChangeDatatypeInSprintPlannings < ActiveRecord::Migration
  def change
    change_column :sprint_plannings, :sprint_desc, :text
  end
end
