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

	class CronReporting < ActiveRecord::Base
	  set_table_name ="cron_reportings"
	end

	class User < ActiveRecord::Base
	set_table_name ="users"
	end


	@find_reporting = CronReporting.all

	@find_reporting.each do |r|
		
		@user = User.find_by_nickname(r.reporting_name)
		
    if @user!=nil
		puts"1111----#{@user.nickname}-----#{@user.id}------"
		@update_reporting = CronReporting.find(r.id)
		@update_reporting.reporting_id = @user.id
		@update_reporting.save!
	else
		puts"-2222---#{r.reporting_name}----aaa--"
	end
	end
