class CreateProjectDomains < ActiveRecord::Migration
  def change
    create_table :project_domains do |t|
      t.string :domain_name
      t.integer :active
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
