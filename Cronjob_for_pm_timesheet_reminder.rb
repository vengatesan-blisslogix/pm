require "rubygems"
require "active_record"
require "mail"
require "action_mailer"


ActiveRecord::Base.establish_connection({
  :adapter => 'postgresql',
  :user => 'postgres',
  :password => 'postgres',
  :database => 'pm_development',
  :host => 'localhost'
})

Mail.defaults do
delivery_method :smtp, { 


         :address => "smtp.gmail.com",
         :port => "587",
         :domain => "gmail.com",
         :enable_starttls_auto => true,
         :authentication => :login,
         :user_name => "yogeshblisslogix@gmail.com",
         :password => "Krish@bliss"
}
end

class User < ActiveRecord::Base
set_table_name ="users"
end
class ProjectUser < ActiveRecord::Base
set_table_name ="project_users"
end
class ProjectMaster < ActiveRecord::Base
set_table_name ="project_masters"
end
class Logtime < ActiveRecord::Base
set_table_name ="logtimes"
end

def send_reminder_to_all_users(to,name,pro_details)
  mail = Mail.new
	mail.sender = "yogeshblisslogix@gmail.com"
	#mail.to = to
	mail.to = "sastrayogesh@gmail.com"
	mail.subject = "[REMINDER][Timesheet Entry]"
	mail.content_type = "multipart/mixed"

  html_part = Mail::Part.new do
    content_type 'text/html; charset=UTF-8'
    body "  
    <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
    <meta name='GENERATOR' content='OpenOffice.org 2.0  (Win32)' />
    <meta name='AUTHOR' content='user1' />
    <meta name='CREATED' content='20071015;19030000' />
    <meta name='CHANGEDBY' content='ASIF ALI' />
    <meta name='CHANGED' content='20071015;19030000' />
    <style>
    	<!--
    		@page { size: 8.5in 11in; margin: 0.79in }
    		P { margin-bottom: 0.08in }
    		A:link { color: #0000ff }
    .style18 {
    	font-family: Arial, Helvetica, sans-serif;
    	font-size: 12px;
    }
    .style19 {
    	color: #FF3300;
    	font-weight: bold;
    }
    .style20 {
    	font-family: Arial;
    	font-size: 12px;
    }
    
    	-->    	
    	</style>
    <body link='#0000ff' dir='ltr'><table width='750' border='0' align='center' cellpadding='0' cellspacing='0'>

Dear #{name},<br/><br>

Please enter your Timesheet for this week.<br/><br>
#{pro_details}

<br>If you have already entered, please ignore this mail.<br/><br>

Thanks & Regards,<br>
<img src = 'http://tvsnext.io/wp-content/uploads/2016/04/logo.png'>

    </body>
    </html>"
  end
  text_part = Mail::Part.new do
    body "TEXT"
  end
  mail.part :content_type => "multipart/alternative" do |p|
    p.html_part = html_part
    p.text_part = text_part
  end
  mail.deliver

end#def send_reminder_to_all_users()

@today = Date.today
@week_days=["#{@today-5}","#{@today-4}","#{@today-3}","#{@today-2}","#{@today-1}"]
@all_user = User.where("active = 'active' and id=1")
@all_user.each do |au|
  puts "#{au.email}"
mail_body = []
@find_project_for_user = ProjectUser.where("user_id=#{au.id}")
@find_project_for_user.each do |pu|
@time_sheet_present = 0 
  @week_days.each do |day|
@find_timesheet_entry = Logtime.where("project_master_id=#{pu.project_master_id} and user_id=#{au.id} and date='#{day}'") 
if @find_timesheet_entry!=nil and @find_timesheet_entry.size!=0
@time_sheet_present =1
end
end#@week_days.each do |day|
@project = ProjectMaster.find_by_id(pu.project_master_id)
if @time_sheet_present==0

  mail_body << "#{@project.project_name}"


end


end#@find_project_for_user.each do |pu|

pro_details = ""
if  mail_body!=[]
  mail_body.uniq.each do  |p|
    if pro_details==""
pro_details = "The Following Projects are not entered timesheet.
#{p}"
    else
pro_details = pro_details+"<br>"+"#{p}"
    end
  end
end



	 send_reminder_to_all_users(au.email,au.name,pro_details)
end #@all_user.each do |au|



