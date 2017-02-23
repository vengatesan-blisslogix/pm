class AddLoginAccountToCronIntranets < ActiveRecord::Migration
  def change
    add_column :cron_intranets, :login_account, :string
  end
end
