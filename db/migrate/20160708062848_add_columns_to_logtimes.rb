class AddColumnsToLogtimes < ActiveRecord::Migration
  def change
    add_column :logtimes, :approved_by, :string
    add_column :logtimes, :approved_at, :datetime
    add_column :logtimes, :rejected_by, :string
    add_column :logtimes, :rejected_at, :datetime
    add_column :logtimes, :comments, :string
  end
end
