class AddDeliveryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :delivery, :integer
  end
end
