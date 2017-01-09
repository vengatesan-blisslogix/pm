class ReChangeDateFormatInProjectTasks < ActiveRecord::Migration
  def change
  	change_table :project_tasks do |t|
      t.change :planned_duration, :date
      t.change :actual_duration, :date
    end
  end
end
