class CreateChecklistRejects < ActiveRecord::Migration
  def change
    create_table :checklist_rejects do |t|
      t.string  :stage_name
      t.text    :reason
      t.integer :user_id
      t.integer :checklist_id
      t.integer :taskboard_id

      t.timestamps null: false
    end
  end
end
