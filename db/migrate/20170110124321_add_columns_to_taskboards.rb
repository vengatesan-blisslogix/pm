class AddColumnsToTaskboards < ActiveRecord::Migration
  def change
    add_column :taskboards, :released, :boolean, :default => false
    add_column :taskboards, :closed, :boolean, :default => false
  end
end
