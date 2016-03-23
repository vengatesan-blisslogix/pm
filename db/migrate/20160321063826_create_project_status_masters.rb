class CreateProjectStatusMasters < ActiveRecord::Migration
  def change
    create_table :project_status_masters do |t|
      t.string :status

      t.timestamps null: false
    end
  end
end
