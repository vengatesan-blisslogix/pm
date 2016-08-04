class AddTaskCompleteToTaskboards < ActiveRecord::Migration
  def change
    add_column :taskboards, :task_complete, :integer
  end
end
