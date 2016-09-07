class AddDateToChecklistRejects < ActiveRecord::Migration
  def change
    add_column :checklist_rejects, :date, :date
  end
end
