class TrackIdToAssigns < ActiveRecord::Migration
  def change
  	  add_column :assigns, :track_id, :integer
  end
end
