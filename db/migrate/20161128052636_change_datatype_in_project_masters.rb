class ChangeDatatypeInProjectMasters < ActiveRecord::Migration
  def change
  	change_column :project_masters, :description, :text
  end
end
