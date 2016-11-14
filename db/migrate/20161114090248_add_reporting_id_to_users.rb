class AddReportingIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reporting_id, :string
  end
end
