class AddAttachmentToProjectTaskAttachments < ActiveRecord::Migration
   def self.up
   	  change_table :project_task_attachments do |t|
        t.attachment :avatar
   	  end
   end

   def self.down
	  remove_attachment :project_task_attachments, :avatar
   end
end
