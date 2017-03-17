require "rubygems"
require "active_record"
require "mail"
require "action_mailer"
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


Mail.defaults do
delivery_method :smtp, { 


         :address => "smtp.gmail.com",
         :port => "587",
         :domain => "gmail.com",
         :enable_starttls_auto => true,
         :authentication => :login,
         :user_name => "pmo@tvsnext.io",
         :password => "pmo#123$"
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
class ProjectTaskMapping < ActiveRecord::Base
set_table_name ="project_task_mappings"
end
class ProjectTask < ActiveRecord::Base
set_table_name ="project_tasks"
end
class Taskboard < ActiveRecord::Base
set_table_name ="taskboards"
end
class Assign < ActiveRecord::Base
set_table_name ="assigns"
end
@today = Date.today
#@week_days=["#{@today-7}","#{@today-6}","#{@today-5}","#{@today-4}","#{@today-3}"]
@all_user = User.where("active = 'active' and id=227")
@week_days=["#{@today-5}","#{@today-4}","#{@today-3}","#{@today-2}","#{@today-1}"]
#@all_user = User.where("active = 'active' and id=308")
@all_user.each do |au|
  
  #puts "#{au.email}"
if au.email!="" and au.email!=nil
mail_body = []
@find_project_for_user = ProjectUser.where("user_id=#{au.id}")
@project_id = ""
@pro_id = []
@find_project_for_user.each do |pu|
if @pro_id.include?(pu.project_master_id.to_s)
else
if @project_id == ""
@project_id = pu.project_master_id
else
@project_id = @project_id.to_s+","+pu.project_master_id.to_s
end
end
end#@find_project_for_user.each do |pu|
@table_cont = ""
@table_cont_details = ""
puts"@project_id@project_id---#{@project_id}"
if @project_id!=""
@project_all = ProjectMaster.where("id IN(#{@project_id})")


@project_all.each do |pro|

@time_sheet_present = []
@week_days.each do |day|
@find_timesheet_entry = Logtime.where("project_master_id=#{pro.id} and user_id=#{au.id} and date='#{day}'") 
  if @find_timesheet_entry!=nil and @find_timesheet_entry.size!=0
    @find_timesheet_entry.each do |logtime|
     @time_sheet_present << logtime.task_time
    end#@find_timesheet_entry.each do |logtime|
  end
end#@week_days.each do |day|
puts"@time_sheet_present.sum----#{@time_sheet_present.sum}"
if @time_sheet_present.sum.to_i < 40

@pro_task_mapping = Taskboard.where("project_master_id=#{pro.id}")

#-------table for details --------


@thead_details = ""

@week_days.each do |day|
if @thead_details==""
@thead_details="<td align='center'>#{day.to_date.strftime("%d/%m/%Y")}</td>"
else
@thead_details=@thead_details+"<td align='center'>#{day.to_date.strftime("%d/%m/%Y")}</td>"
end # if @thead==""
end#@week_days.each do |day|
@task_tbody = ""
@pro_task_mapping.each do |task_map|
  @task_name_assign = Assign.where("taskboard_id=#{task_map.id} and assigned_user_id=#{au.id}")

if  @task_name_assign!=nil and  @task_name_assign.size!=0

@task_name = ProjectTask.find_by_id(task_map.task_master_id)
  if @task_name !=nil and @task_name.task_name!="Leave"
@tbody_details = "<td align='center'>#{@task_name.task_name}</td>"
@week_days.each do |day|
@find_timesheet_log_details = Logtime.where("project_master_id=#{pro.id} and user_id=#{au.id} and date='#{day}' and task_master_id=#{task_map.task_master_id}") 
  if @find_timesheet_log_details!=nil and @find_timesheet_log_details.size!=0
    @log_time_details = @find_timesheet_log_details[0].task_time
  else
    @log_time_details = 0
  end
@tbody_details=@tbody_details+"<td align='center'>#{@log_time_details}</td>"
end#@week_days.each do |day|
@tbody_details ="<tr style='background-color: #d0dfe5;'>#{@tbody_details}</tr>"

if @task_tbody==""
@task_tbody=@tbody_details
else
@task_tbody=@task_tbody+@tbody_details
end # if @thead==""

end# if @task_name !=nil
end# if  @task_name_assign!=nil and  @task_name_assign.size!=0

end#@pro_task_mapping.each do |task_map|


@thead_details = "<tr style='background-color: #FFA500;'><td align='center'>Task Name</td>#{@thead_details}</tr>"

@table_cont_details = "<table width='750' border='1' align='center' cellpadding='0' cellspacing='0'>#{@thead_details}#{@task_tbody}</table>"


#-------table for details --------
#-------table for summary --------
@thead = ""
@tbody = "<td align='center'>#{au.name}</td>"
@week_days.each do |day|
if @thead==""
@thead="<td align='center'>#{day.to_date.strftime("%d/%m/%Y")}</td>"
else
@thead=@thead+"<td align='center'>#{day.to_date.strftime("%d/%m/%Y")}</td>"
end # if @thead==""
@find_timesheet_log = Logtime.where("project_master_id=#{pro.id} and user_id=#{au.id} and date='#{day}'") 
  if @find_timesheet_log!=nil and @find_timesheet_log.size!=0
    @log_time = @find_timesheet_log[0].task_time
  else
    @log_time = 0
  end

@tbody=@tbody+"<td align='center'>#{@log_time}</td>"

end#@week_days.each do |day|
@tbody ="<tr style='background-color: #d0dfe5;'>#{@tbody}</tr>"

@thead = "<tr style='background-color: #FFA500;'><td align='center'>Name</td>#{@thead}</tr>"


if @table_cont == ""
@table_cont = @table_cont_details +"<br/><br><br/><br>Details:<br>"+ "<table width='750' border='1' align='center' cellpadding='0' cellspacing='0'>#{@thead}#{@tbody}</table>"
else
@table_cont = @table_cont.to_s+"<br/><br><br/><br>"+@table_cont_details +"<br/><br><br/><br>Details:<br>"+ "<table width='750' border='1' align='center' cellpadding='0' cellspacing='0'>#{@thead}#{@tbody}</table>"
end

#-------table for summary --------
puts "#{au.email}"
 




end#if @time_sheet_present.sum.to_i < 40
end#@project_all.each do |pro|
end#if @project_id!=""





end





#mail  part
mail = Mail.new
  mail.sender = "pmo@tvsnext.io"
  mail.to = "yogesh.s1@tvsnext.io"
  #mail.to = "sastrayogesh@gmail.com"
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
    <body link='#0000ff' dir='ltr'>

Dear #{au.name},<br/><br>

Oops !!, Did you forget to enter your timesheets<br/><br>
Summary:<br>
#{@table_cont}


<br>We seriously don't mind even if you have already entered, again just a reminder.
<br/><br>

Thanks<br>
Linchpin Team
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
#mail  part





   #send_reminder_to_all_users(au.email,au.name,pro_details)
end #@all_user.each do |au|
