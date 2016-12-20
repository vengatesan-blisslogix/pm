class AddSignoffDateToProjectrequestforms < ActiveRecord::Migration
  def change
    add_column :project_request_forms, :signoff_date, :date
  end
end
