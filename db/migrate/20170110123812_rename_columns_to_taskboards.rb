class RenameColumnsToTaskboards < ActiveRecord::Migration
  def change
    rename_column :taskboards, :new, :un_assigned
    rename_column :taskboards, :in_progress, :assigned
    rename_column :taskboards, :development_completed, :tech_spec
    rename_column :taskboards, :qa, :development
    rename_column :taskboards, :completed, :testing
    rename_column :taskboards, :hold, :uat

  end
end
