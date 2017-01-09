class ChangeDateFormatInProjectTasks < ActiveRecord::Migration
 def change
  	  change_table :project_tasks do |t|
      t.change :planned_duration, :float
      t.change :actual_duration, :float

    end
  end
end