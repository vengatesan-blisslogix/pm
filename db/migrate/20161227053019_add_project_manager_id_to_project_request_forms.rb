class AddProjectManagerIdToProjectRequestForms < ActiveRecord::Migration
  def change
    add_column :project_request_forms, :project_manager_id, :integer
  end
end
