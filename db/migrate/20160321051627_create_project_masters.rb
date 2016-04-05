class CreateProjectMasters < ActiveRecord::Migration
  def change
    create_table :project_masters do |t|
      t.string :billable
      t.string :project_name
      t.string :description
      t.string :project_image
      t.integer :domain_id
      t.integer :client_id
      t.integer :created_by_user_id
      t.date :start_date
      t.date :end_date
      t.integer :project_status_master_id
      t.string :website
      t.string :facebook_page
      t.string :twitter_page
      t.integer :star_rating
      t.string :active
      t.string :tag_keywords
      t.integer :flag_id
      t.string :approved
      t.integer :approved_by_user_id
      t.datetime :approved_date_time
      t.integer :assigned_to_user_id
      t.date :kickstart_date

      t.timestamps null: false
    end
  end
end
