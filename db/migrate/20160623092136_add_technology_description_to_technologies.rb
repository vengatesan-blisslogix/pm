class AddTechnologyDescriptionToTechnologies < ActiveRecord::Migration
  def change
    add_column :technology_masters, :description, :string
  end
end
