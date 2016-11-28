class ChangeDatatypeInReleasePlannings < ActiveRecord::Migration
  def change
      change_column :release_plannings, :comments, :text
	  change_column :release_plannings, :release_notes, :text
  end
end
