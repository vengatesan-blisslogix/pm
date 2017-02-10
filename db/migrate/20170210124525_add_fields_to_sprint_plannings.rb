class AddFieldsToSprintPlannings < ActiveRecord::Migration
  def change
    add_column :sprint_plannings, :sc_start, :date
    add_column :sprint_plannings, :sc_end, :date
    add_column :sprint_plannings, :delay_type, :integer
  end
end
