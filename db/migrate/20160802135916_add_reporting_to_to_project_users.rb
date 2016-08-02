class AddReportingToToProjectUsers < ActiveRecord::Migration
  def change
    add_column :project_users, :reporting_to, :string
  end
end
