require "rubygems"
require "active_record"
require "activerecord-sqlserver-adapter"
require "tiny_tds"
require "mysql2"


ActiveRecord::Base.establish_connection({
  :adapter => 'mysql2',
  :user => 'root',
  :password => 'tvsnext',
  :database => 'pm_development',
  :host => 'localhost'
})

	class User < ActiveRecord::Base
	  set_table_name ="users"
	end

	class CronReporting < ActiveRecord::Base
	  set_table_name ="cron_reportings"
	end


	client = TinyTds::Client.new username: 'pmpuser', password: 'pmp#123$', host: '10.91.19.245', database: 'HRIS'

	#result = client.execute("SELECT * FROM empBasicViewForApp")
	result = client.execute("SELECT * FROM HRIS.dbo.empBasicViewForApp WHERE leftOrg='false';")

    result.each do |u|
       #p u['reporting_to']
        if u['leftOrg'] == false and u['email'] != nil
       
	       @find_user = User.find_by_email(u['email'])
			if @find_user != nil
			@user = User.find_by_email(u['email'])
			#@user.nickname = u['name']+" "+"(#{u['empNo']})"
			#@user.save #reporting_to run no 2
				if @user!=nil and u['reportingTo'] != nil
				@find_repo = CronReporting.where("reporting_name ='#{u['reportingTo']}'")
			  	if @find_repo != nil and @find_repo.size!=0
                  	@user.reporting_to_id= @find_repo[0].reporting_id
                  	@user.reporting_to= @find_repo[0].reporting_name
                  	@user.reporting_id= @find_repo[0].reporting_id.to_s+"|"+@find_repo[0].reporting_name
                  	@user.save#reporting_to run no 2
                  end
                  
			   
				#@user.reporting_to = u['reportingTo'].split("(")[0].strip
				@user.save
				end
		   else
		    @user = User.new
	   		@user.employee_no 		= u['empNo']
			@user.name 				= u['name'].split(" ")[0]
			@user.last_name 		= u['name'].split(" ")[1]
			@test_doj 				= Date.parse(u['doj'])
			@user.doj         		= @test_doj.to_date

			@test_dob 				= Date.parse(u['dob'])
			@user.dob         		= @test_dob.to_date

			@user.prior_experience 	= u['previousExperience']
			@user.email 			= u['email']
			@user.password 			= u['email'][0..2]+"#123$"
			@user.active 			= "active"
			@user.mobile_no			= u['mobile']
			@user.nickname = u['name']+" "+"(#{u['empNo']})"

				if u['reportingTo'] != nil			 
					@user.reporting_to		= u['reportingTo'].split("(")[0].strip
				else
					@user.reporting_to		= u['reportingTo']
				end
		    
		    @user.uid 				= u['email']
		    @user.branch_id 		= 1
			@user.company_id 		= 1
			@user.role_master_id 	= 2      
		 
	      @user.save
		   end
		else

			       p "$$$$$$$$$#{u['email']}"

		end
    end




