class AddOtpColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :otp, :integer
  end
end
