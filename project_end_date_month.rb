require "rubygems"
require "active_record"
require "mail"
require "action_mailer"


  ActiveRecord::Base.establish_connection({
    :adapter => 'mysql2',
    :user => 'root',
    :password => 'tvsnext',
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
           :user_name => "pmo@tvsnext.io",
           :password => "pmo#123$"
  }
  end

    class User < ActiveRecord::Base
    set_table_name ="users"
    end
    class ProjectMaster < ActiveRecord::Base
    set_table_name ="project_masters"
    end

      @project_all = ProjectMaster.all

      @project_all.each do |pro|
        @mail_day = (pro.end_date - Date.today).to_i        
        if @mail_day.to_i == 31 or @mail_day.to_i == 30
          puts "#{pro.project_name}--S"
        else
          puts"#{pro.project_name}--F"
        end 
        puts"------------------#{@mail_day}"
      end

    #-------table for details --------


      @thead_details= ""

      @week_days.each do |day|
      if @thead_details==""
      @thead_details="<td align='center'>#{day.to_date.strftime("%d/%m/%Y")}</td>"
      else
      @thead_details=@thead_details+"<td align='center'>#{day.to_date.strftime("%d/%m/%Y")}</td>"
      end # if @thead==""
      end#@week_days.each do |day|
      @task_tbody = ""
      @pro_task_mapping.each do |task_map|
        @task_name = ProjectTask.find_by_id(task_map.project_task_id)
        if @task_name !=nil
      @tbody_details = "<td align='center'>#{@task_name.task_name}</td>"
      @week_days.each do |day|
      @find_timesheet_log_details = Logtime.where("project_master_id=#{pro.id} and user_id=#{au.id} and date='#{day}' and task_master_id=#{task_map.project_task_id}") 
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


      end#@pro_task_mapping.each do |task_map|


      @thead_details = "<tr style='background-color: #FFA500;'><td align='center'>Task Name</td>#{@thead_details}</tr>"
      table_cont_details = "<table width='750' border='1' align='center' cellpadding='0' cellspacing='0'>#{@thead_details}#{@task_tbody}</table>"
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
      table_cont = "<table width='750' border='1' align='center' cellpadding='0' cellspacing='0'>#{@thead}#{@tbody}</table>"
      #-------table for summary --------


      #mail  part
      mail = Mail.new
        mail.sender = "pmo@tvsnext.io"
        mail.to = au.email
        #mail.to = "sastrayogesh@gmail.com"
        mail.subject = "[REMINDER][Timesheet Entry] - #{pro.project_name}"
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

      Dear PMO,<br/><br>

      Did you notice that following project contract is going to be expire within the following days<br/><br>
      Project Name : <b>#{pro.project_name}</b><br/><br>
      Details:<br>
      #{table_cont_details}
      <br>It's Just a reminder.
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

      end#if @time_sheet_present.sum.to_i < 40
      end#@project_all.each do |pro|
      end#if @project_id!=""
         #send_reminder_to_all_users(au.email,au.name,pro_details)
      end #@all_user.each do |au|

