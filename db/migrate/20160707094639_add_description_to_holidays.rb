class AddDescriptionToHolidays < ActiveRecord::Migration
  def change
    add_column :holidays, :description, :string
  end
end
