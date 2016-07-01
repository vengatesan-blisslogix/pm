class ChangeDataTypeForDurationInProjectTasks < ActiveRecord::Migration
  def change
  	change_table :project_tasks do |t|
    t.change :planned_duration, :time
    t.change :actual_duration, :time
   end
  end
end
