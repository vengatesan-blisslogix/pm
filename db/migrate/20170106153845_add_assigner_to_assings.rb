class AddAssignerToAssings < ActiveRecord::Migration
  def change
    add_column :assigns, :assigneer_id, :integer
  end
end
