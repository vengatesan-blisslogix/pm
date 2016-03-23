class AddUserIdColumnToClientSource < ActiveRecord::Migration
  def change
    add_column :client_sources, :user_id, :integer
  end
end
