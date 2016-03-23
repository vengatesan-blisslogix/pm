class AddUserIdToTeamMasters < ActiveRecord::Migration
  def change
     add_column :team_masters, :user_id, :integer
  end
end
