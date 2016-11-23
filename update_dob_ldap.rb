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

	class User < ActiveRecord::Base
	  set_table_name ="users"
	end

	class CronReporting < ActiveRecord::Base
	  set_table_name ="cron_reportings"
	end


client = TinyTds::Client.new username: 'pmpuser', password: 'pmp#123$', host: '10.91.19.245', database: 'HRIS'

result = client.execute("SELECT * FROM empBasicViewForApp")
    result.each do |u|
       #p u['reporting_to']
        if u['leftOrg'] == false and u['email'] != nil
	       @find_user = User.find_by_email(u['email'])
			if @find_user != nil		
			  @find_user.dob          	= u['dob'].to_date
			  puts "-------#{@find_user.dob}-----------dob----------"
			  @find_user.save!
			end
		end
    end




