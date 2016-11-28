class ChangeDatatypeInClients < ActiveRecord::Migration
  def change
  	change_column :clients, :comments, :text
  end
end
