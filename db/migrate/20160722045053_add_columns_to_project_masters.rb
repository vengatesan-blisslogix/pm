class AddColumnsToProjectMasters < ActiveRecord::Migration
  def change
    add_column :project_masters, :sow_number, :string
    add_column :project_masters, :account_manager, :string
    add_column :project_masters, :project_manager, :string
    add_column :project_masters, :business_unit_id, :string
    add_column :project_masters, :project_location_id, :string
    add_column :project_masters, :engagement_type_id, :string
    add_column :project_masters, :project_payment_id, :string

  end
end
