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

	class CronReporting < ActiveRecord::Base
	  set_table_name ="cron_reportings"
	end

	class User < ActiveRecord::Base
	set_table_name ="users"
	end

	class CronIntranet < ActiveRecord::Base
	set_table_name ="cron_intranets"
	end


@intranet_all_reporting = CronIntranet.find_by_sql("SELECT DISTINCT emp_reporting_to FROM cron_intranets WHERE emp_reporting_to IS NOT NULL")


@intranet_all_reporting.each do |intra|

@find_reporting = CronReporting.where("reporting_name='#{intra.emp_reporting_to}'")

	if @find_reporting!=nil and @find_reporting.size!=0
      else#if @find_reporting!=nil and @find_reporting.size!=0
        @new_reporting = CronReporting.new
        @new_reporting.reporting_name = intra.emp_reporting_to
        @user = User.find_by_nickname(intra.emp_reporting_to)
		if @user!=nil
		@new_reporting.reporting_id = @user.id
		end
		@new_reporting.save
	end#if @find_reporting!=nil and @find_reporting.size!=0
end#@intranet_all_reporting.each do |intra|
	



# @find_reporting = CronReporting.all

# @find_reporting.each do |r|

# @user = User.find_by_nickname(r.reporting_name)

# if @user!=nil
# puts"1111----#{@user.nickname}-----#{@user.id}------"
# @update_reporting = CronReporting.find(r.id)
# @update_reporting.reporting_id = @user.id
# @update_reporting.save!
# else
# puts"-2222---#{r.reporting_name}----aaa--"
# end
# end
