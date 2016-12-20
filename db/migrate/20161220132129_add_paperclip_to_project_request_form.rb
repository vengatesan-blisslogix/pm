class AddPaperclipToProjectRequestForm < ActiveRecord::Migration
  def change
  	add_attachment :project_request_forms, :signed_copy
  	add_attachment :project_request_forms, :mail_approval
  end
end
