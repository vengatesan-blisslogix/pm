class AddFieldsToReleasePlannings < ActiveRecord::Migration
  def change
    add_column :release_plannings, :sc_start, :date
    add_column :release_plannings, :sc_end, :date
    add_column :release_plannings, :delay_type, :integer
  end
end
