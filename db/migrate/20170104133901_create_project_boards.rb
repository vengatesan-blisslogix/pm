class CreateProjectBoards < ActiveRecord::Migration
  def change
    create_table :project_boards do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
