class AddOriginalPasswordColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :original_password, :string
  end
end
