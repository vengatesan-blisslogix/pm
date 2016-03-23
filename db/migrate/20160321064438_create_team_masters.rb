class CreateTeamMasters < ActiveRecord::Migration
  def change
    create_table :team_masters do |t|
      t.string :team_name
      t.string :description
      t.string :active

      t.timestamps null: false
    end
  end
end
