class AddEmployeeNoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :employee_no, :string
  end
end
