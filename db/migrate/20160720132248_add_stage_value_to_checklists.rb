class AddStageValueToChecklists < ActiveRecord::Migration
  def change
    add_column :checklists, :stage_value, :integer
  end
end
