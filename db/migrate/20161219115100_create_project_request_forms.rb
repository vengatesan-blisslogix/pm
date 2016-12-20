class CreateProjectRequestForms < ActiveRecord::Migration
  def change
    create_table :project_request_forms do |t|
      t.string :project_name
      t.string :project_manager
      t.integer :project_type_id
      t.string :billable
      t.text :project_description
      t.integer :project_domain_id
      t.string :client_name
      t.date :kickstart_date
      t.date :planned_start_date
      t.date :planned_end_date
      t.string :tag_keyword
      t.integer :project_status_master_id
      t.integer :project_location_id
      t.string :sow_no
      t.boolean :signoff_attachment
      t.string :account_manager_name
      t.string :website_page
      t.string :facebook_page
      t.string :twitter_page
      t.integer :business_unit_id
      t.integer :enagement_type_id
      t.string :payment_cylce
      t.string :team_member_allocation

      t.timestamps null: false
    end
  end
end
