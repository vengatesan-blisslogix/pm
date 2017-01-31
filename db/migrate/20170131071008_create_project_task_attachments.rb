class CreateProjectTaskAttachments < ActiveRecord::Migration
  def change
    create_table :project_task_attachments do |t|
      t.integer :project_task_id
      t.integer :updated_by
      t.integer :delete_status      

      t.timestamps null: false
    end
  end
end
