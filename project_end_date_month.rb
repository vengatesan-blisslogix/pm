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
           :user_name => "sastrayogesh@gmail.com",
           :password => "krish_15"
  }
  end

    class ProjectMaster < ActiveRecord::Base
    set_table_name ="project_masters"
    end

      @project_all = ProjectMaster.all    
        

   #-------table for details --------


  @thead_details= ""

  @project_all.each do |pro|
    @mail_day = (pro.end_date - Date.today).to_i        
      if @mail_day.to_i == 31 or @mail_day.to_i == 30
        puts "#{pro.project_name}--S"
      else
        puts"#{pro.project_name}--F"
      end 
        puts"------------------#{@mail_day}"
      
        if @thead_details==""
        @thead_details="<td align='center'>#{pro.project_name}--S</td>"
        else
        @thead_details=@thead_details+"<td align='center'>#{pro.project_name}--F</td>"
        end # if @thead==""

  @task_tbody = ""

  @tbody_details = "<td align='center'>#{pro.project_name}</td>"


      #mail  part
      mail = Mail.new
        mail.sender = "pmo@tvsnext.io"
        mail.to = "manickavelu.t@tvsnext.io"
        #mail.to = "sastrayogesh@gmail.com"
        mail.subject = "[REMINDER 1][PROJECT END DATE] - #{pro.project_name}"
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

      Did you notice that the following project is going to end with the following days<br/><br>
      Project Name : <b>#{pro.project_name}</b><br/><br>


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
dsd
  end#@project_all.each do |pro|

