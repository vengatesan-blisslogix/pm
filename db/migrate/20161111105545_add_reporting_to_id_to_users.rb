class AddReportingToIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reporting_to_id, :integer
  end
end
