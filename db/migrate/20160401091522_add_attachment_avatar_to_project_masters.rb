class AddAttachmentAvatarToProjectMasters < ActiveRecord::Migration
  def self.up
   change_table :project_masters do |t|
     t.attachment :avatar
   end
 end

 def self.down
   remove_attachment :project_masters, :avatar
 end
end
