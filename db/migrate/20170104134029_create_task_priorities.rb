class CreateTaskPriorities < ActiveRecord::Migration
  def change
    create_table :task_priorities do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
