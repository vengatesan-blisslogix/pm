class AddProjectTypeIdColumnToProjectMaster < ActiveRecord::Migration
  def change
    add_column :project_masters, :project_type_id, :integer
  end
end
