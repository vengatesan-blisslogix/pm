class RemoveFieldsFromTaskboards < ActiveRecord::Migration
  def change
    remove_column :taskboards, :un_assigned, :boolean
    remove_column :taskboards, :assigned, :boolean
    remove_column :taskboards, :tech_spec, :boolean
    remove_column :taskboards, :development, :boolean
    remove_column :taskboards, :testing, :boolean
    remove_column :taskboards, :uat, :boolean
    remove_column :taskboards, :released, :boolean
    remove_column :taskboards, :closed, :boolean
  end
end
