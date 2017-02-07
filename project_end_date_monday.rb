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
        if @mail_day.to_i <= 1 or @mail_day.to_i <= 7
          puts "#{pro.project_name}--S"
        else
          puts"#{pro.project_name}--F"
        end 
        puts"------------------#{@mail_day}"
      end