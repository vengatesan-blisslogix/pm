class CreateCronReportings < ActiveRecord::Migration
  def change
    create_table :cron_reportings do |t|
      t.integer :reporting_id
      t.string :reporting_name

      t.timestamps null: false
    end
  end
end
