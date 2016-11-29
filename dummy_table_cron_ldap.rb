require "rubygems"
require "active_record"
require "activerecord-sqlserver-adapter"
require "tiny_tds"
require "mysql2"


ActiveRecord::Base.establish_connection({
  :adapter => 'mysql2',
  :user => 'root',
  :password => 'tvsnext',
  :database => 'pm_production',
  :host => 'localhost'
})

	class CronIntranet < ActiveRecord::Base
	  set_table_name ="cron_intranets"
	end

client = TinyTds::Client.new username: 'pmpuser', password: 'pmp#123$', host: '10.91.19.245', database: 'HRIS'

result = client.execute("SELECT * FROM HRIS.dbo.empBasicViewForApp WHERE leftOrg='false';")

    result.each do |u|
       #p u['email']
        #if u['leftOrg'] == true
        	
	       @cront_intranet = CronIntranet.find_by_emp_email(u['email'])
	       if @cront_intranet != nil
		    @cront_intranet = CronIntranet.find_by_emp_email(u['email'])
		   else
		    @cront_intranet = CronIntranet.new
	   		@cront_intranet.emp_codes 			= u['empNo']
			@cront_intranet.emp_name 			= u['name']
			
			@cront_intranet.emp_gender 			= u['gender']
			@cront_intranet.emp_doj				= u['doj']
			@cront_intranet.emp_status          = u['status']
			@cront_intranet.emp_reporting_to 	= u['reportingTo']
			@cront_intranet.emp_department 		= u['department']
			@cront_intranet.emp_location 		= u['location']
			@cront_intranet.emp_company 		= u['company']
			@cront_intranet.emp_current_exp		= u['currentExperience']			 
		    @cront_intranet.emp_previous_exp 	= u['previousExperience']
		    @cront_intranet.emp_total_exp 		= u['totalExperience']
			@cront_intranet.emp_left_org 		= u['leftOrg']
			@cront_intranet.emp_dob 			= u['dob']
			@cront_intranet.emp_dow				= u['dow'] 
			@cront_intranet.emp_blood_group		= u['bloodGroup']
			@cront_intranet.emp_phone			= u['phone']
			@cront_intranet.emp_mobile			= u['mobile']
			@cront_intranet.emp_email			= u['email']
			@cront_intranet.emp_photo			= u['photoFile']
		    "--------------->#{@cront_intranet.emp_codes}<---------"		   
	     @cront_intranet.save
		   end
		#else
			       #p "$$$$$$$$$#{u['email']}"

		#end
    end





