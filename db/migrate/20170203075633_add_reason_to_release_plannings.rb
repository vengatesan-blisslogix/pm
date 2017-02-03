class AddReasonToReleasePlannings < ActiveRecord::Migration
  def change
    add_column :release_plannings, :reason, :text
  end
end
