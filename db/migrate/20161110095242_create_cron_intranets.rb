class CreateCronIntranets < ActiveRecord::Migration
  def change
    create_table :cron_intranets do |t|

	  	 t.string :emp_codes, primary: true
		 t.string :emp_name
		 t.string :emp_gender
		 t.date   :emp_doj
		 t.string :emp_status
		 t.string :emp_reporting_to
		 t.string :emp_department
		 t.string :emp_location
		 t.string :emp_company
		 t.string :emp_current_exp
		 t.string :emp_previous_exp
		 t.string :emp_total_exp
		 t.boolean :emp_left_org
		 t.datetime :emp_dob
		 t.datetime :emp_dow
		 t.string :emp_blood_group
		 t.string :emp_phone
		 t.string :emp_mobile
		 t.string :emp_email, primary: true
		 t.string :emp_photo


      t.timestamps null: false
    end
  end
end
