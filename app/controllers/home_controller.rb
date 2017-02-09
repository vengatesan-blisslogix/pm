require 'rubygems'
require 'net/ldap'

class HomeController < ApplicationController
  def index
    @project_masters = ProjectMaster.all
  end

  def reason_history
    @f_history = []
      @find_rel_reason = ReleasePlanningReason.where("project_master_id = #{params[:project_master_id]}")        
        @rel_reason = []
        @find_rel_reason.each do |fr|
          @rel_det = ReleasePlanning.find_by_id(fr.project_master_id)
          if @rel_det!=nil and @rel_det!=""
            @release_name =@rel_det.release_name
            @release_ph = @rel_det.planned_hours
            @release_ah = @rel_det.actual_hours
            @release_sd = @rel_det.start_date
            @release_ed = @rel_det.end_date
          else
            @release_name = ""
            @release_ph   = ""
            @release_ah   = ""
            @release_sd   = ""
            @release_ed   = ""
          end
          @rel_reason << {
            'release_planning_id' => fr.release_planning_id,
            'name' => @release_name,
            'actual_hours' => @release_ah,
            'planned_hours' => @release_ph,
            'start_date' => @release_sd,
            'end_date' => @release_ed,
            'date_reason' => fr.date_reason,
            'hour_reason' => fr.hour_reason,
            'project_master_id' => fr.project_master_id
          }
        end
        @find_spr_reason = SprintPlanningReason.where("project_master_id = #{params[:project_master_id]}")
        @spr_reason = []
        @find_spr_reason.each do |fs|
          @spr_det = SprintPlanning.find_by_id(fs.project_master_id)
          if @spr_det!=nil and @spr_det!=""
            @sprint_name =@spr_det.sprint_name
            @sprint_ph = @spr_det.planned_hours
            @sprint_ah = @spr_det.actual_hours
            @sprint_sd = @spr_det.start_date
            @sprint_ed = @spr_det.end_date
          else
            @sprint_name = ""
            @sprint_ph   = ""
            @sprint_ah   = ""
            @sprint_sd   = ""
            @sprint_ed   = ""
          end
          @spr_reason << {
            'sprint_planning_id' => fs.sprint_planning_id,
            'name' => @sprint_name,
            'actual_hours' => @sprint_ah,
            'planned_hours' => @sprint_ph,
            'start_date' => @sprint_sd,
            'end_date' => @sprint_ed,
            'date_reason' => fs.date_reason,
            'hour_reason' => fs.hour_reason,
            'project_master_id' => fs.project_master_id
          }
        end
        @find_ta_reason = ProjectTaskReason.where("project_master_id = #{params[:project_master_id]}")
        @ta_reason = []
        @find_ta_reason.each do |ta|
          @pt_det = ProjectTask.find_by_id(ta.project_master_id)
          if @pt_det!=nil and @pt_det!=""
            @task_name =@pt_det.task_name
            @task_ph = @pt_det.planned
            @task_ah = @pt_det.actual
            @task_pd = @pt_det.planned_duration
            @task_ad = @pt_det.actual_duration
          else
            @task_name = ""
            @task_ph   = ""
            @task_ah   = ""
            @task_pd   = ""
            @task_ad   = ""
          end
          @ta_reason << {
            'project_task_id' => ta.project_task_id,
            'name' => @task_name,
            'actual_hours' => @task_ph,
            'planned_hours' => @task_ah,
            'start_date' => @task_pd,
            'end_date' => @task_ad,
            'date_reason' => ta.date_reason,
            'hour_reason' => ta.hour_reason,
            'project_master_id' => ta.project_master_id
          }
        end
          @f_history << {
            'release_histroy' => @rel_reason,
            'release_count' => @rel_reason.count,
            'sprint_histroy' => @spr_reason,
            'sprint_count' => @spr_reason.count,
            'task_histroy' => @ta_reason,
            'task_count' => @ta_reason.count
          }
      
      render json: @f_history
  end

  def delete_task
      @del_task = ProjectTask.find_by_id(params[:id])
      @del_task.is_delete = 1
      @del_task.save
      render json: { valid: true, msg:"#{@del_task.task_name} deleted successfully."}
  end

  def status_list
    @list = SprintStatus.all
      @status_resp=[]
      @list.each do |ss| 

        @status_resp << {
         'sprint_status_id' => ss.id,
         'status_name' => ss.status,
        }
      end
      render json: @status_resp
  end

  def unassigned_list
    @find_taskboard = Taskboard.where("task_status_master_id = 1 and project_master_id = #{params[:project_master_id]}")
      @un_assigned = []
      @find_taskboard.each do |ft|
        @list = ProjectTask.find_by_id(ft.task_master_id)
          if @list != nil
          @un_assigned << {
            'id' => @list.id,
            'task_name' => @list.task_name
          }
        end
      end
    render json: @un_assigned
  end

  def task_assign
    @task_assign = Assign.new
      @task_assign.taskboard_id = params[:taskboard_id]
      @task_assign.assigned_user_id = user
      @task_assign.assigneer_id = params[:user_id]
    @task_assign.save!
  end
  def assign_list
    #get_all_projects
    @user_resp = []
      @find_project_user = ProjectUser.where("project_master_id = #{params[:project_master_id]}")
        @manager_resp = []
        @prouser_resp = []
        @find_project_user.each do |pu|
          @user = User.find_by_id(pu.user_id)
          @engage = ProjectMaster.find_by_id(params[:project_master_id])
          puts "#{@engage.engagement_type_id.to_i == 2}********engagement*****"
          if @engage != nil and @engage.engagement_type_id.to_i == 2
            puts "******engae if*******#{@user.id}"
            if pu.manager.to_i == 1
              puts"#{@user.id}-------------"
              @manager_resp << {
                'assigneer_id' => @user.id,        
                'assigner_name' => "#{@user.name} #{@user.last_name}",
              }
               @prouser_resp << {
                'assigned_user_id' => @user.id,        
                'assignee_name' => "#{@user.name} #{@user.last_name}",
              }
            else
              puts"#{@user.id}*************"
               @prouser_resp << {
                'assigned_user_id' => @user.id,        
                'assignee_name' => "#{@user.name} #{@user.last_name}",
              }
            end
          else
            puts "***********#{@user.id}.............."
            if pu.manager.to_i == 1
            @manager_resp << {
                'assigneer_id' => @user.id,        
                'assigner_name' => "#{@user.name} #{@user.last_name}",
              }
            else
              @prouser_resp << {
                'assigned_user_id' => @user.id,        
                'assignee_name' => "#{@user.name} #{@user.last_name}",
              }
            end
          end
        end    
         @user_resp = {
            'assignee_list' => @prouser_resp,
            'count' => @prouser_resp.count,
            'assigner_list' => @manager_resp,
            'default' => @default_pro
          }    
          render json: @user_resp    
  end

  def default_pro
    @default_proj = User.find_by_id(params[:user_id])
    @default_proj.default_project_id   = params[:default_project_id ]
    @default_proj.save
        render json: { valid: true, msg:"#{@default_proj.name} This is your default project."}
  end

  def all_sprint
    get_all_projects
    @sprint_resp=[]
    if  @admin.to_i == 1      
    @all_sprint = SprintPlanning.all  
        elsif @default_pro.to_i != 0
    @all_sprint = SprintPlanning.where("project_master_id = #{@default_pro}")                 
    else
        if @search_all_pro_id==""
          @search_all_pro="project_master_id IN(0)"
        else
          @search_all_pro="project_master_id IN(#{@search_all_pro_id})"
        end
      @all_sprint = SprintPlanning.where("#{@search_all_pro}")  
    end
      @all_sprint.each do |sp| 

        @sprint_resp << {
         'sprint_planning_id' => sp.id,
         'sprint_name' => sp.sprint_name,
        }
      end
      render json: @sprint_resp
  end

  def all_release    
     get_all_projects
      @release_resp=[]
    puts "-------#{@admin}--  #{@default_pro}----"
    if params[:project_master_id] 
      @all_release = ReleasePlanning.where("project_master_id = #{params[:project_master_id]}")  
    else
        if  @admin.to_i == 1
        @all_release = ReleasePlanning.all  
        elsif @default_pro.to_i != 0
        @all_release = ReleasePlanning.where("project_master_id = #{@default_pro}")  
        else
            if @search_all_pro_id==""
              @search_all_pro="project_master_id IN(0)"
            else
              @search_all_pro="project_master_id IN(#{@search_all_pro_id})"
            end
          @all_release = ReleasePlanning.where("#{@search_all_pro}")  
        end
    end
          @all_release.each do |rp| 

            @release_resp << {
             'release_planning_id' => rp.id,
             'release_name' => rp.release_name,
            }
          end
    
          render json: @release_resp
  end

  def all_priority
    @all_priority = TaskPriority.all     
      @priority_resp=[]
      @all_priority.each do |tp| 

        @priority_resp << {
         'priority_id' => tp.id,
         'priority_name' => tp.name,
        }
      end
      render json: @priority_resp
  end

  def all_status
    @all_status = TaskStatusMaster.all     
      @status_resp=[]
      @all_status.each do |ts| 

        @status_resp << {
         'project_board_id' => ts.id,
         'project_board_status' => ts.status,
        }
      end
      render json: @status_resp
  end


  def project
    get_all_projects
    @projects = ProjectMaster.order(:created_at => 'desc')
    #@project = []
      #@projects.each do |p|
        #@project << {
          #'value' => p.id,
          #'label' => p.project_name
        #}
      #end
      @respone = {
        'list' => @project_resp,
        'count' => @project_resp.count,
        'default_project_id' => @default_pro
      }
      render json: @respone
  end

  def set_priority
    @task = Task.find_by_id(params[:task_id])
    @task.task_priority_id = params[:task_priority_id]
    @task.save
        render json: { valid: true, msg:"#{@task.name}-priority updated successfully."}
  end

  def set_stage
    @task = Taskboard.find_by_id(params[:taskboard_id])
    @task.task_status_master_id = params[:task_status_master_id]
    @task.save
        render json: { valid: true, msg:"updated successfully"}
  end

def get_regions
   @region_all = Region.all.order(:name)
      @region_resp=[]
      @region_all.each do |r| 

        @region_resp << {
         'id' => r.id,
         'region_name' => r.name,
         'region_code' => r.code
        }
      end
      render json: @region_resp
end

  def user_ldap_auth
    resp = []
    puts"====#{params[:password]}----#{params[:username]}---------"
  if params[:username] and params[:password]
    
  
    ldap = Net::LDAP.new :host => "10.91.19.110",
       :port => 389,
       :auth => {
             :method => :simple,
             :base  =>       "DC=TVSi,DC=local",
             :username => "tvsi" + "\\" +params[:username],
             :password => params[:password]
       }

    is_authorized = ldap.bind # returns true if auth works, false otherwise (or throws error if it can't connect to the server)

    attrs = []
    puts is_authorized

render :json => is_authorized
  else
    render :json => resp
  end
  end


def search_user
        resp=[]

  if params[:search] != nil
    @su = User.where("name like '#{params[:search]}%'")
    @su.each do |search|
        resp << {
            'name' => search.name,
            'employee_no' => search.employee_no,
            'email' => search.email
            }
          end
  elsif params[:email] != nil
    @user = User.find_by_email(params[:email])
        resp << {
        'name' => @user.name,
        'last_name' => @user.last_name,
        'nickname' => @user.nickname,
        'email' => @user.email,
        'mobile_no' => @user.mobile_no,
        'office_phone' => @user.office_phone,
        'home_phone' => @user.home_phone,
        'profile_photo' => @user.profile_photo,
        'avatar_file_name' => @user.avatar,
        'active' => @user.active,
        'prior_experience' => @user.prior_experience,
        'doj' => @user.doj,
        'dob' => @user.dob,
        'team_id' =>@user.team_id,
        'created_by_user' => @user.created_by_user,
        'reporting_to' => @user.reporting_to,
        'branch_id' => @user.branch_id,
        'company_id' => @user.company_id,
        'role_master_id' => @user.role_master_id,     
        'employee_no' => @user.employee_no,
        'user_technology' => @tech_name
    }
  end
     render json: resp
end

def user_eldap
  resp = [] 
    
    if params[:userTag] 
    
      ldap = Net::LDAP.new :host => "10.91.19.110",
         :port => 389,
         :auth => {
               :method => :simple,
               :base  =>       "DC=TVSi,DC=local",
               :username => "administrator@tvsi.local",
               :password => "@dm1n@969"
         }

      is_authorized = ldap.bind # returns true if auth works, false otherwise (or throws error if it can't connect to the server)

      attrs = []
      puts is_authorized
      #puts ldap.search(:filter => "sAMAccountName=yogesh.s1").first

     # search_param = params[:email]
      result_attrs = ["l", "mail", "employeeId", "givenName", "sn", "extensionAttribute1", "extensionAttribute3", "mobile", "manager", "department", ]

      # Build filter
      @user_search = params[:userTag]
      if @user_search.include? "@"
        search_filter = Net::LDAP::Filter.eq("mail",@user_search +"*")
      else 
        search_filter = Net::LDAP::Filter.eq("mail",@user_search + "*")
        #search_filter = Net::LDAP::Filter.eq("mail",@user_search + "*@tvsnext.io") If tvsnext present
      end
        
      puts search_filter
      puts params[:email]
      # Execute search
      puts ldap.search(:base => "DC=TVSi,DC=local", :filter => search_filter) { |item| 
        begin      
        
      if params[:email].to_i != 1
        puts item.mail.first
        resp << {
          :branch_id => item.l.first,
          :email => item.mail.first,
          :employee_no => item.employeeID.first,
          :name => item.givenName.first,
          :last_name => item.sn.first,
          :dob => item.extensionAttribute1.first,
          :doj => item.extensionAttribute3.first,
          :mobile_no => item.mobile.first,
          :reporting_to => item.manager.first[3..-1].split(' ')[0].gsub("\\",""),
          :team_id => item.department.first
        } 
      
      else
        puts item.mail.first
        resp << {
          :email => item.mail.first
        }
      end
        rescue Exception => e
         #resp << e 
        end
        #{}"#{item.sAMAccountName.first}: #{item.displayName.first} (#{item.mail.first})" 
        
      }
     #else
      #render :json => resp
    end
   render :json => resp
    
end



def report_1
# Create a new Excel Workbook
date = Time.now.strftime("%m/%d/%Y")
date1 = Time.now.strftime("%m-%d-%Y")

@end_date = Date.today
@start_date = @end_date-5

d = DateTime.now


@file_name = "Projectwise_Resource_Report_#{d}.xls"
workbook = WriteExcel.new("#{Rails.root}/#{@file_name}")

# Add worksheet(s)
worksheet1  = workbook.add_worksheet

# Add and define a format

format = workbook.add_format
format.set_bold
format.set_size(10)
format.set_bg_color('cyan')
format.set_color('black')
format.set_border(1)

format1 = workbook.add_format
format1.set_size(10)
format1.set_color('black')
format1.set_text_wrap(1)
format1.set_align('top')

worksheet1.set_column('A:A', 10,format1)
worksheet1.set_column('B:B', 25,format1)
worksheet1.set_column('C:C', 25,format1)
worksheet1.set_column('D:D', 25,format1)
worksheet1.set_column('E:E', 25,format1)
worksheet1.set_column('F:F', 25,format1)
worksheet1.set_column('G:G', 25,format1)


worksheet1.set_row(4,20)

# write a formatted and unformatted string.
worksheet1.write(4,0, 'No', format)
worksheet1.write(4,1, 'Project Name', format)
worksheet1.write(4,2, 'User Name', format)
worksheet1.write(4,3, 'Sprint Name', format)
worksheet1.write(4,4, 'Billable hour', format)
worksheet1.write(4,5, 'Non-Billable hour', format)
worksheet1.write(4,6, 'Total hour', format)

row=5
serial=1

  @project_masters=ProjectMaster.where("project_status_master_id != 6")
  @project_masters.each do |pm|
    worksheet1.write(row,0, serial, format1)
    worksheet1.write(row,1, "#{pm.project_name}", format1)

      @project_user = ProjectUser.where("project_master_id = #{pm.id}")

        @project_user.each do |pu|
          @user_name = User.find_by_id(pu.user_id)
            worksheet1.write(row,2, "#{@user_name.name}#{@user_name.last_name}", format1)

            @find_assign = Assign.where("assigned_user_id =#{pu.user_id}")
            @sprint_id = ""
            @find_assign.each do |fa|

              @sprint = Taskboard.where("id = #{fa.taskboard_id}")
                if @sprint != "" and @sprint != nil   and @sprint.size != 0   
                    if @sprint_id==""
                      @sprint_id=@sprint[0].sprint_planning_id
                    else
                      @sprint_id=@sprint_id.to_s+","+@sprint[0].sprint_planning_id.to_s
                    end
                end
               end
                if @sprint_id != ""
                  @sprint_planning = SprintPlanning.where("id IN(#{@sprint_id})")
                  @sprint_planning.each do |sp|
                  @sprint_name = sp.sprint_name
                  worksheet1.write(row,3, "#{@sprint_name}", format1)


            @timesheet_summ_user_time = Logtime.where("sprint_planning_id=#{sp.id} and project_master_id=#{pm.id} and user_id=#{pu.user_id}").sum(:task_time)
                    if pu.is_billable == 'yes'
                                worksheet1.write(row,4, "#{@timesheet_summ_user_time}", format1)
                    else
                        worksheet1.write(row,5, "#{@timesheet_summ_user_time}", format1)
                    end
                        worksheet1.write(row,6, "#{@timesheet_summ_user_time}", format1)

                    row = row +1
                end
          else
            worksheet1.write(row,3, "---", format1)

            row = row +1
          end
      end
  serial = serial + 1
end
workbook.close
#send_file("#{@file_name}" ,
  #    :filename     =>  "#{@file_name}",
  #    :charset      =>  'utf-8',
  #    :type         =>  'application/octet-stream')

end


def report_2
# Create a new Excel Workbook
date = Time.now.strftime("%m/%d/%Y")
date1 = Time.now.strftime("%m-%d-%Y")

@end_date = Date.today
@start_date = @end_date-5

d = DateTime.now

@file_name = "Resourcewise_project_Report_#{d}.xls"
workbook = WriteExcel.new("#{Rails.root}/#{@file_name}")

# Add worksheet(s)
worksheet1  = workbook.add_worksheet

# Add and define a format

format = workbook.add_format
format.set_bold
format.set_size(10)
format.set_bg_color('cyan')
format.set_color('black')
format.set_border(1)

format1 = workbook.add_format
format1.set_size(10)
format1.set_color('black')
format1.set_text_wrap(1)
format1.set_align('top')

worksheet1.set_column('A:A', 20,format1)
worksheet1.set_column('B:B', 25,format1)
worksheet1.set_column('C:C', 25,format1)
worksheet1.set_column('D:D', 25,format1)
worksheet1.set_column('E:E', 25,format1)
worksheet1.set_column('F:F', 25,format1)
worksheet1.set_column('G:G', 25,format1)
worksheet1.set_column('H:H', 25,format1)
worksheet1.set_column('I:I', 25,format1)
worksheet1.set_column('J:J', 25,format1)


worksheet1.set_row(4,20)

# write a formatted and unformatted string.
worksheet1.write(4,0, 'No', format)
worksheet1.write(4,1, 'Employee Code', format)
worksheet1.write(4,2, 'User Name', format)
worksheet1.write(4,3, 'Project Name', format)
worksheet1.write(4,4, 'Task Name', format)
worksheet1.write(4,5, 'Skill Set', format)
worksheet1.write(4,6, 'Overall Experience', format)
worksheet1.write(4,7, 'Billable hour', format)
worksheet1.write(4,8, 'Non-Billable hour', format)
worksheet1.write(4,9, 'Total hour', format)


row=5
serial=1

  @users=User.all
  @users.each do |u|
    worksheet1.write(row,0, serial, format1)
    worksheet1.write(row,1, "#{u.employee_no}", format1)
    worksheet1.write(row,2, "#{u.name}#{u.last_name}", format1)
    @skill_set = UserTechnology.where("user_id = #{u.id}")
                  @technology_name=""
                  @skill_set.each do |tech|
                  tec = TechnologyMaster.find_by_id(tech.technology_master_id)
                    if @technology_name == ""
                    @technology_name = tec.technology
                    else
                    @technology_name = @technology_name+", "+tec.technology
                    end
                  end#@skill_set.each do |tec|
                  if @technology_name != ""
                    @tech_name = @technology_name
                  else
                    @tech_name = "-"
                  end
                  worksheet1.write(row,5, "#{@tech_name}", format1)
                 # @current_exp = ((Date.today - u.doj)/365)

                 # worksheet1.write(row,6, "#{u.prior_experience}", format1)


                @current_exp = Date.today - u.doj.to_date
                @ce = (@current_exp/30).round

                @tot = @ce + u.prior_experience

                  worksheet1.write(row,6, "#{@tot}", format1)
               

      @project_user = ProjectUser.where("user_id = #{u.id}")

        @project_user.each do |pu|
          @project_name = ProjectMaster.find_by_id(pu.project_master_id)
            worksheet1.write(row,3, "#{@project_name.project_name}", format1)
        
          @project_task = Assign.where("assigned_user_id =#{pu.user_id}")

          @task_name = ""
          @project_task.each do |pjt|
          @pf = Taskboard.find_by_id(pjt.taskboard_id)
          if @pf!=nil and @pf.project_master_id == pu.project_master_id
                      @pt_name = ProjectTask.find_by_id(@pf.task_master_id)
                      if @task_name==""
                                @task_name=@pt_name.task_name
                              else
                                @task_name=@task_name.to_s+","+@pt_name.task_name
                              end   
          end
          end
          worksheet1.write(row,4, "#{@task_name}", format1)


         @find_assign = Assign.where("assigned_user_id =#{pu.user_id}")
            @sprint_id = ""
            @find_assign.each do |fa|

              @sprint = Taskboard.where("id = #{fa.taskboard_id}")
                if @sprint != "" and @sprint != nil   and @sprint.size != 0   
                    if @sprint_id==""
                      @sprint_id=@sprint[0].sprint_planning_id
                    else
                      @sprint_id=@sprint_id.to_s+","+@sprint[0].sprint_planning_id.to_s
                    end
                end
               end
                if @sprint_id != ""
                  @sprint_planning = SprintPlanning.where("id IN(#{@sprint_id})")
                  @sprint_planning.each do |sp|

            @timesheet_summ_user_time = Logtime.where("sprint_planning_id=#{sp.id} and project_master_id=#{pu.id} and user_id=#{pu.user_id}").sum(:task_time)
                    if pu.is_billable == 'yes'
                                worksheet1.write(row,7, "#{@timesheet_summ_user_time}", format1)
                    else
                        worksheet1.write(row,8, "#{@timesheet_summ_user_time}", format1)
                    end
                        worksheet1.write(row,9, "#{@timesheet_summ_user_time}", format1)

                    row = row +1
                end
          else
            worksheet1.write(row,3, "---", format1)

            row = row +1
          end
        end
    serial = serial + 1
  end
  workbook.close

  #send_file("#{@file_name}" ,
    #    :filename     =>  "#{@file_name}",
    #    :charset      =>  'utf-8',
    #    :type         =>  'application/octet-stream')

  end


def report_3
# Create a new Excel Workbook
date = Time.now.strftime("%m/%d/%Y")
date1 = Time.now.strftime("%m-%d-%Y")

@end_date = Date.today
@start_date = @end_date-5

d = DateTime.now


@file_name = "Categorywise_project_Report_#{d}.xls"
workbook = WriteExcel.new("#{Rails.root}/#{@file_name}")

# Add worksheet(s)
worksheet1  = workbook.add_worksheet

# Add and define a format

format = workbook.add_format
format.set_bold
format.set_size(10)
format.set_bg_color('cyan')
format.set_color('black')
format.set_border(1)

format1 = workbook.add_format
format1.set_size(10)
format1.set_color('black')
format1.set_text_wrap(1)
format1.set_align('top')

worksheet1.set_column('A:A', 20,format1)
worksheet1.set_column('B:B', 25,format1)
worksheet1.set_column('C:C', 25,format1)
worksheet1.set_column('D:D', 25,format1)
worksheet1.set_column('E:E', 25,format1)
worksheet1.set_column('F:F', 25,format1)


worksheet1.set_row(0,20)

# write a formatted and unformatted string.
worksheet1.write(4,0, 'No', format)
worksheet1.write(4,1, 'Billable Type', format)
worksheet1.write(4,2, 'Project Name', format)
worksheet1.write(4,3, 'Billable hour', format)
worksheet1.write(4,4, 'Non-Billable hour', format)
worksheet1.write(4,5, 'Total hour', format)


row=5
serial=1

 @project_user = ProjectUser.all

        @project_user.each do |pu|
              worksheet1.write(row,0, serial, format1)

        if pu.is_billable == 'yes'
          @billable = 'billable'
        else
          @billable = 'non-billable'
        end
          worksheet1.write(row,1, "#{@billable}", format1)


          @user_name = ProjectMaster.find_by_id(pu.project_master_id)
            worksheet1.write(row,2, "#{@user_name.project_name}", format1)

            @find_assign = Assign.where("assigned_user_id =#{pu.user_id}")
            @sprint_id = ""
            @find_assign.each do |fa|

              @sprint = Taskboard.where("id = #{fa.taskboard_id}")
                if @sprint != "" and @sprint != nil   and @sprint.size != 0   
                    if @sprint_id==""
                      @sprint_id=@sprint[0].sprint_planning_id
                    else
                      @sprint_id=@sprint_id.to_s+","+@sprint[0].sprint_planning_id.to_s
                    end
                end
               end
                if @sprint_id != ""
                  @sprint_planning = SprintPlanning.where("id IN(#{@sprint_id})")
                  @sprint_planning.each do |sp|
                  @sprint_name = sp.sprint_name
                  #worksheet1.write(row,3, "#{@sprint_name}", format1)


            @timesheet_summ_user_time = Logtime.where("sprint_planning_id=#{sp.id} and project_master_id=#{pu.project_master_id} and user_id=#{pu.user_id}").sum(:task_time)
                    if pu.is_billable == 'yes'
                                worksheet1.write(row,3, @timesheet_summ_user_time, format1)
                      worksheet1.write(row,4, 0, format1)
                    else
                      worksheet1.write(row,3, 0, format1)
                        worksheet1.write(row,4, @timesheet_summ_user_time, format1)
                    end
                        worksheet1.write(row,5, @timesheet_summ_user_time, format1)

                    row = row +1
                end
          else
              worksheet1.write(row,3, 0, format1)
              worksheet1.write(row,4, 0, format1)
              worksheet1.write(row,5, 0, format1)

            row = row +1
          end
      
  serial = serial + 1
end
workbook.close

#send_file("#{@file_name}" ,
  #    :filename     =>  "#{@file_name}",
  #    :charset      =>  'utf-8',
  #    :type         =>  'application/octet-stream')

end


def report_4
# Create a new Excel Workbook
date = Time.now.strftime("%m/%d/%Y")
date1 = Time.now.strftime("%m-%d-%Y")

@end_date = Date.today
@start_date = @end_date-5

d = DateTime.now


@file_name = "Categorywise_skillset_Report_#{d}.xls"
workbook = WriteExcel.new("#{Rails.root}/#{@file_name}")

# Add worksheet(s)
worksheet1  = workbook.add_worksheet

# Add and define a format

format = workbook.add_format
format.set_bold
format.set_size(10)
format.set_bg_color('cyan')
format.set_color('black')
format.set_border(1)

format1 = workbook.add_format
format1.set_size(10)
format1.set_color('black')
format1.set_text_wrap(1)
format1.set_align('top')

worksheet1.set_column('A:A', 20,format1)
worksheet1.set_column('B:B', 25,format1)
worksheet1.set_column('C:C', 25,format1)
worksheet1.set_column('D:D', 25,format1)
worksheet1.set_column('E:E', 25,format1)
worksheet1.set_column('F:F', 25,format1)
worksheet1.set_column('G:G', 25,format1)



worksheet1.set_row(0,20)

# write a formatted and unformatted string.
worksheet1.write(4,0, 'No', format)
worksheet1.write(4,1, 'Billable Type', format)
worksheet1.write(4,2, 'Skill Set', format)
worksheet1.write(4,3, 'Years of Experience', format)
worksheet1.write(4,4, 'Billable hour', format)
worksheet1.write(4,5, 'Non-Billable hour', format)
worksheet1.write(4,6, 'Total hour', format)


row=5
serial=1

 @project_user = ProjectUser.all

        @project_user.each do |pu|
              worksheet1.write(row,0, serial, format1)

        if pu.is_billable == 'yes'
          @billable = 'billable'
        else
          @billable = 'non-billable'
        end
          worksheet1.write(row,1, "#{@billable}", format1)


          @skill_set = UserTechnology.where("user_id = #{pu.user_id}")
            @technology_name=""
            @skill_set.each do |tech|
            tec = TechnologyMaster.find_by_id(tech.technology_master_id)
              if @technology_name == ""
              @technology_name = tec.technology
              else
              @technology_name = @technology_name+", "+tec.technology
              end
            end#@skill_set.each do |tec|
            if @technology_name != ""
              @tech_name = @technology_name
            else
              @tech_name = "-"
            end
            
        worksheet1.write(row,2, "#{@tech_name}", format1)

            @find_assign = Assign.where("assigned_user_id =#{pu.user_id}")
            @sprint_id = ""
            @find_assign.each do |fa|

              @sprint = Taskboard.where("id = #{fa.taskboard_id}")
                if @sprint != "" and @sprint != nil   and @sprint.size != 0   
                    if @sprint_id==""
                      @sprint_id=@sprint[0].sprint_planning_id
                    else
                      @sprint_id=@sprint_id.to_s+","+@sprint[0].sprint_planning_id.to_s
                    end
                end
               end

                @user = User.find_by_id(pu.user_id)

                @tvs_exp = Date.today - @user.created_at.to_date
                @tvs_exp = (@tvs_exp/30).round

                if @prior_experience != nil and @prior_experience != ""

                @tot_exp = @tvs_exp + @user.prior_experience

                  worksheet1.write(row,3, "#{@tot_exp}", format1)
                else
                  worksheet1.write(row,3, "#{@tvs_exp}", format1)
                end
                if @sprint_id != ""
                  @sprint_planning = SprintPlanning.where("id IN(#{@sprint_id})")
                  @sprint_planning.each do |sp|
                  @sprint_name = sp.sprint_name
                  #worksheet1.write(row,3, "#{@sprint_name}", format1)


            @timesheet_summ_user_time = Logtime.where("sprint_planning_id=#{sp.id} and project_master_id=#{pu.project_master_id} and user_id=#{pu.user_id}").sum(:task_time)
                    if pu.is_billable == 'yes'
                                worksheet1.write(row,4, @timesheet_summ_user_time, format1)
                      worksheet1.write(row,5, 0, format1)
                    else
                      worksheet1.write(row,4, 0, format1)
                        worksheet1.write(row,5, @timesheet_summ_user_time, format1)
                    end
                        worksheet1.write(row,6, @timesheet_summ_user_time, format1)

                    row = row +1
                end
          else
              worksheet1.write(row,4, 0, format1)
              worksheet1.write(row,5, 0, format1)
              worksheet1.write(row,6, 0, format1)

            row = row +1
          end
      
  serial = serial + 1
end
workbook.close

#send_file("#{@file_name}" ,
  #    :filename     =>  "#{@file_name}",
  #    :charset      =>  'utf-8',
  #    :type         =>  'application/octet-stream')

end


def report_5
# Create a new Excel Workbook
date = Time.now.strftime("%m/%d/%Y")
date1 = Time.now.strftime("%m-%d-%Y")

@end_date = Date.today
@start_date = @end_date-5

d = DateTime.now

@file_name = "Projectwise_sprint_Report_#{d}.xls"
workbook = WriteExcel.new("#{Rails.root}/#{@file_name}")

# Add worksheet(s)
worksheet1  = workbook.add_worksheet

# Add and define a format

format = workbook.add_format
format.set_bold
format.set_size(10)
format.set_bg_color('cyan')
format.set_color('black')
format.set_border(1)

format1 = workbook.add_format
format1.set_size(10)
format1.set_color('black')
format1.set_text_wrap(1)
format1.set_align('top')

worksheet1.set_column('A:A', 20,format1)
worksheet1.set_column('B:B', 25,format1)
worksheet1.set_column('C:C', 25,format1)
worksheet1.set_column('D:D', 25,format1)


worksheet1.set_row(0,20)

# write a formatted and unformatted string.
worksheet1.write(4,0, 'No', format)
worksheet1.write(4,1, 'Project Name', format)
worksheet1.write(4,2, 'Sprint Name', format)
worksheet1.write(4,3, 'In-Voice status', format)


row=1

workbook.close

#send_file("#{@file_name}" ,
  #    :filename     =>  "#{@file_name}",
  #    :charset      =>  'utf-8',
  #    :type         =>  'application/octet-stream')

end

  def user_tech
  @skill_set = UserTechnology.where("user_id = #{params[:user_id]}")
    @technology_name=""
    @user_projects = ProjectUser.where("user_id = #{params[:user_id]}")
    userr_proj =[]
    @user_projects.each do |up|
      @proj_na = ProjectMaster.find_by_id(up.project_master_id) 
      if @proj_na != nil
      userr_proj << {
            'utilization' => up.utilization,
            'project_name' => @proj_na.project_name
            }
          end
    end

    @skill_set.each do |tech|
    tec = TechnologyMaster.find_by_id(tech.technology_master_id)
      if @technology_name == ""
      @technology_name = tec.technology
      else
      @technology_name = @technology_name+", "+tec.technology
      end
    end#@skill_set.each do |tec|
    if @technology_name != ""
      @tech_name = @technology_name
    else
      @tech_name = "-"
    end
    resp=[]
        resp << {
            'technology' => @tech_name,
            'user_utilization' => userr_proj
            }
            render json: resp

end

def log_hours
  @start_date = Date.today.at_beginning_of_week
  @end_date =  @start_date + 5
 @search="task_date between '#{@start_date}' and '#{@end_date}' and user_id=#{params[:user_id]} and   project_master_id = #{params[:project_master_id]} and sprint_planning_id = #{params[:sprint_planning_id]} and task_master_id = #{params[:task_master_id]}"
 
  resp = []
  @find_summary = Logtime.where("#{@search}")
  @find_summary.each do |fs|
    resp << {
    'date' => fs.task_date.strftime("%m/%d/%Y"),
    'hours' => fs.task_time
    }
  end

  pagination(Logtime,@search)
  response = {
      'no_of_records' => @no_of_records.size,
      'date' => resp
      }
    render json: response 
  end
 
def role_mapping

  def getaccess(role_id)
    resp = []
    @access_value = ActivityMaster.all
    @access_value.each do |access|
      @activity = RoleActivityMapping.where("role_master_id=#{role_id} and activity_master_id=#{access.id}")
      if @activity!=nil and @activity.size!=0
        @selected = true
      else
        @selected = false
      end
      resp << {
        'id' => access.id,
        'action' => access.activity_Name,
        'selected' => @selected
      }
    end
    resp
    pagination(ActivityMaster,@search)
    
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'roles' => resp
    }
  end   

  resp=[]
  @role = RoleMaster.where("id = #{params[:id]}").first
  
          #puts "********#{@role.id}******"

     resp << {
        'id' => @role.id,
        'role_name' => @role.role_name,
        'description' => @role.description,
        'status' => @role.active,
        'activity' => getaccess(@role.id)
      }
      render json: resp
 
end

 def user_profile
  @user = User.find_by_id(params[:id])
    begin
      @user.name = params[:name]
      @user.last_name = params[:last_name]
      @user.email = params[:email]
      @user.mobile_no = params[:mobile_no]
      @user.avatar = params[:avatar]
      @user.active = params[:active]
      @user.employee_no = params[:employee_no]
      
      @user.save
       render json: { valid: true, msg:"#{@user.name} updated successfully."}
     rescue
      render json: { valid: false, error: "Invalid parameters" }, status: 404
     end
  end

 def view_user_profile
    resp=[]

    if @user = User.find_by_id(params[:id])
       # @user.each do |up| 

          resp << {
              'id' => @user.id,
              'name' => @user.name,
              'last_name' => @user.last_name,
              'email' => @user.email,
              'mobile_no' => @user.mobile_no,
              'avatar_file_name' => @user.avatar,
              'active' => @user.active,
              'employee_no' => @user.employee_no,
          }
      end
    #end
          render json: resp

  end

  def manager_master
    user = Spreadsheet.open('PMT.xls')
    sheet1 = user.worksheet('RM Details') # can use an index or worksheet name
    sheet1.each do |row|
      puts row[7] # looks like it calls "to_s" on each cell's Value
      
      @user = User.find_by_email(row[9])
      puts "#{row[9]}-----#{@user}---"
      if @user != nil         
        @user.password = "password"
        @user.save      
      else
      @user = User.new
      @user.employee_no = row[0]
      @user.name = row[1]
      @user.last_name = row[2]
      @user.doj = row[3]
      @user.active = row[4]
      @user.prior_experience = row[6]
      @user.email = row[8]
      @user.password = row[9]
      @user.active = "active"

        @user.save
    end
      #@user.prior_experience = row[6]
      #@user.reporting_to = row[7]

    end
  end

  def employee_master
    user = Spreadsheet.open('PMT.xls')
    sheet1 = user.worksheet('Employee Details') # can use an index or worksheet name
    sheet1.each do |row|
      puts row[7] # looks like it calls "to_s" on each cell's Value
      @user = User.find_by_email(row[9])
      puts "#{row[9]}-----#{@user}---"
      if @user != nil         
        @user.password = "password"
        @user.save
      else
        @user = User.new
        @user.employee_no = row[0]
        @user.name = row[1]
        @user.last_name = row[2]
        @user.doj = row[3]
        @user.active = row[4]
        @user.prior_experience = row[6]
        @user.email = row[9]
        @user.password = "password"
      end
      @user.active = "active"
      @user.branch_id = 1
      @user.delivery = 1
      @user.company_id = 1
      @user.role_master_id = 2#role_master = user

      @find_reporting_to = User.find_by_email(row[7])
      if @find_reporting_to != nil 
        @user.reporting_to =  @find_reporting_to.id
      end

      @team_name = ""
      if row[5].to_s == "IOS"
        @team_name = "IOS"
      elsif  row[5].to_s == "ROR" or row[5].to_s ==".NET" or row[5].to_s == "PHP"
        @team_name = "Backend"
      elsif row[5].to_s == "HTML5" or row[5].to_s =="Angular JS" or row[5].to_s == "UI/UX"
        @team_name = "UI/UX"
      elsif row[5].to_s == "Mobile Dev" or row[5].to_s == "Android"
        @team_name = "Android"
      elsif row[5].to_s == "Business Analyst"
        @team_name = "Functional"
      elsif row[5].to_s == "IOT"
        @team_name = "IOT"
      elsif row[5].to_s == "Testing" or row[5].to_s == "QA"
        @team_name = "Testing"
      elsif row[5].to_s == "Scala"
        @team_name = "Backend"
      end
      if @team_name != ""
        @team_id = TeamMaster.find_by_team_name(@team_name)
        if @team_id != nil
          @user.team_id = @team_id.id   
        end
      end
      puts "-------#{}-----------"
      @user.save

      @find_tech = TechnologyMaster.find_by_technology(row[5])
      if @find_tech != nil
        @user_tech = UserTechnology.new()
        @technology_master_id = @find_tech
        @user_id = @user.id
      end
    
          
      #@user.prior_experience = row[6]
      #@user.reporting_to = row[7]
    end
  end

  def add_menus
=begin
    #add timesheet sub activity
    href = ["home.timesheets" ]
    icon = ["fa fa-fw fa-tachometer"]
    i = 0
    admin = ActivityMaster.find_by_activity_Name("Timesheet")
    ["Timesheets","Timesheet Summary" ].each do |ad|
    ad = ActivityMaster.create(activity_Name: "#{ad}", active: "active",  is_page: "yes", parent_id: admin.id, href: href[i],  icon: icon[i])
    RoleActivityMapping.create(role_master_id: 1, activity_master_id: ad.id, access_value: 1, user_id: 1, active: 1)
    i = i+1
    end  
=end
    if params[:delete_activity].to_i == 1        
      am = ActivityMaster.where("id  > 23" )
      am.each do |a|
      RoleActivityMapping.destroy_all(:activity_master_id => a)
      ActivityMaster.destroy_all(:id => a)
      end
    end

    if params[:percentage].to_i == 1
      @per=5
      while @per < 101
         @per_new = Percentage.new
          @per_new.value = @per
          @per_new.save

      @per = @per+5
      end
    end
  end


def show_checklist
  @find_checklist = Checklist.where("stage_value = #{params[:stage_value]}")
  @checklist_resp = []
  @find_checklist.each do |cl|
    @checklist_resp << {
      'id' => cl.id,
      'checklist_name' => cl.name
    }
  end
    render json: @checklist_resp
end

  #-----------------timesheets---  
  def add_timesheets

    resp =  []
    if params[:date] and params[:date]!=nil
      @start_date = params[:date][0].to_date.at_beginning_of_week
      @end_date =  params[:date][0].to_date.at_end_of_week
      @search="and task_date between '#{@start_date}' and '#{@end_date}' "
      session[:search_task] =@search
    else
      session[:search_task] =""
    end


    if params[:id]!=nil and params[:id]!=""
    #convert_param_to_array(params[:id])
    @project_master_id_array = params[:id]
    @project_master_id_array.each do |pro_id|
          @project_master = ProjectMaster.find_by_id(pro_id)
          get_release_project(@project_master.id)
          get_sprint_release(@project_master.id)
          resp << {
                     'ProjectName' => @project_master.project_name,
                     'ProjectId'    => @project_master.id,
                     'Release'   => @resp_rel, 
                     #'Sprint' => @resp_sprint
                    }
    end
    end
          render json: resp
  end

  def timesheets_records(task_master_id, sprint_id)

  @find_summary = Logtime.where("sprint_planning_id = #{sprint_id} and task_master_id = #{task_master_id} #{session[:search_task]}")
  @task_time = []
      if @find_summary!= nil and @find_summary!="" and @find_summary.size!=0
       

        @find_summary.each do |as|
        @task_time << {'date'=>"#{as.task_date}", 'hour'=>as.task_time}    
        end
      end     
  end

def timesheet_approval
#@assigns = Logtime.find_by_id(params[:id])
@assigns_val = Logtime.where("project_master_id=#{params[:project_master_id]} and task_master_id=#{params[:task_master_id]} and approved_by IS NULL")
puts "----------#{params[:id]}---#{params[:project_master_id]}---#{params[:task_master_id]}--------"
if @assigns_val != nil and @assigns_val.size.to_i!=0

@assigns_val.each do |assign|
  if params[:approve] and params[:approve].to_i==1
    assign.rejected_by = nil
    assign.rejected_at = nil
    assign.comments = nil
    assign.approved_by = params[:approve_by]
    assign.approved_at = Time.now
    assign.status = "approved"
    assign.save!
  elsif params[:approve] and params[:approve].to_i==2
    assign.approved_by = nil
    assign.approved_at = nil
    assign.rejected_by = params[:approve_by]
    assign.rejected_at = Time.now
    assign.status = "rejected"
    assign.comments = params[:comments]
    assign.save!
  elsif params[:approve] and params[:approve].to_i==0
    assign.approved_by = nil
    assign.approved_at = nil
    assign.rejected_by = nil
    assign.rejected_at = nil      
    assign.status = "pending"
    assign.save!  
  end
end#@assigns_val.each do |@assigns|


end#if @assigns_val != nil and @assigns_val.size.to_i!=0  
      render json: { valid: true, msg:"updated successfully."}
end

def timesheet_summary
    if params[:start_date]
      @start_date = params[:start_date] 
      @end_date = params[:start_date].to_date.at_end_of_week
    else
      @start_date = Date.today.at_beginning_of_week
      @end_date =  Date.today.at_end_of_week
    end#if

    @role_masters = RoleMaster.where("role_name like '%PMO%' or role_name like '%PM AND BA% 'or role_name like '%BA%' or role_name like '%PM%'")
        @role_id=[]
        @role_masters.each do |r|   
        @role_id << r.id    
        end

    puts "*****#{@start_date}************#{@role_id}********#{current_user.role_master_id}*****",@role_id.include?(current_user.role_master_id)

    if current_user.role_master_id == 1 
      @search="task_date between '#{@start_date}' and '#{@end_date}'"
    elsif @role_id.include?(current_user.role_master_id)
    @find_reporting_to = ProjectUser.where("manager=1 and user_id=#{current_user.id}")

     @rpro=""
      @find_reporting_to.each do |rp|
        if @rpro==""
        @rpro=rp.project_master_id.to_s
        else
          @rpro=@rpro+","+rp.project_master_id.to_s
        end
      end

      @ruser=""

if @rpro!=""
    @find_reporting_to_user = ProjectUser.where("project_master_id IN(#{@rpro})")

      @find_reporting_to_user.each do |ru|
        if @ruser==""
        @ruser=ru.user_id.to_s
        else
          @ruser=@ruser+","+ru.user_id.to_s
        end
      end
      if @ruser==""
        @search="task_date between '#{@start_date}' and '#{@end_date}' and user_id=#{params[:user_id]} and  id IN(0)"
      else
       @search="task_date between '#{@start_date}' and '#{@end_date}' and user_id IN (#{@ruser})"
      end
    end
    else
      @search="task_date between '#{@start_date}' and '#{@end_date}' and user_id=#{params[:user_id]}"
      
     
    end
      puts "===========#{@search}============="
    @timesheet_summ = Logtime.where("#{@search}")
    resp = []    
    @task_id_uniq=[]
     @timesheet_summ.each do |lts|
if @task_id_uniq.include?(lts.task_master_id)
else
      if lts.project_master_id!=nil  and  lts.project_master_id!=""
      @project_name = ProjectMaster.find_by_id(lts.project_master_id)
          if @project_name != nil
            @proj_name = @project_name.project_name
          else
            @proj_name = ""
          end
            @timesheet_summ_user = Logtime.where("#{@search} and project_master_id=#{lts.project_master_id}").select(:user_id).uniq
            @timesheet_summ_user.each do |tsu|
            @timesheet_summ_user_time = Logtime.where("#{@search} and project_master_id=#{lts.project_master_id} and user_id=#{tsu.user_id} and task_master_id=#{lts.task_master_id}").sum(:task_time)
            @timesheet_summ_id = Logtime.where("#{@search} and project_master_id=#{lts.project_master_id} and user_id=#{tsu.user_id} and task_master_id=#{lts.task_master_id}")
      @resource_name = User.find_by_id(tsu.user_id)
      if @resource_name != nil
        @res_name = @resource_name.name
      else
        @res_name = ""
      end

      @task_na = ProjectTask.find_by_id(lts.task_master_id)
      if @task_na != nil
        @task_name = @task_na.task_name
      else
        @task_name = ""
      end
      if @timesheet_summ_id[0] != nil
        @status_log= Logtime.find_by_id(@timesheet_summ_id[0].id)
        if @status_log!=nil and @status_log.status != nil
          @status = @timesheet_summ_id[0].status
        else
          @status = "pending"
        end

        if @timesheet_summ_id[0].comments != nil
          @comments = @timesheet_summ_id[0].comments
        else
          @comments = ""
        end 
      
      @project_user = ProjectUser.where("manager = 1 and user_id=#{current_user.id}")

      if current_user.role_master_id == 1 or (@project_user != nil and @project_user.size != 0)
        @enable_approve_button = true
      else
       @enable_approve_button=false
      end

     resp << {
              'id' => @timesheet_summ_id[0].id,
              'project_id' => lts.project_master_id,
              'project_name' => @proj_name,
              'resource_name' => @res_name,
              'task_id' => @timesheet_summ_id[0].task_master_id,
              'task_name' => @task_name,
              'start_date' => @start_date,
              'end_date' => @end_date,
              'no_of_hours' => @timesheet_summ_user_time,
              'status' => @status,
              'comments' => @comments
            }

      end#@timesheet_summ_user.each do |tsu|
      end
    end
    @task_id_uniq << lts.task_master_id
  end
  end#@timesheet_summ.each do |lts|
puts"======#{@task_id_uniq}"
          pagination(Logtime,@search)   

      if current_user.role_master_id == 1
      @enable_approve_button = true
      else
        @enable_approve_button=false
      end

      response = {
        'no_of_records' => @no_of_records.size,
        'no_of_pages' => @no_pages,
        'next' => @next,
        'prev' => @prev,
        'show_approve' =>@enable_approve_button,
        'timesheet_summary' => resp
      }
    render json: response 
end

=begin
def past_summary
  @start_date = params[:date][0].to_date.at_beginning_of_week
  @end_date =  @start_date + 5
  resp = []
if params[:project_id] and params[:project_id]!=nil
  params[:project_id].each do |pro_id|

@search="task_date between '#{@start_date}' and '#{@end_date}' "
  @find_summary = Logtime.where("#{@search} and project_master_id = #{pro_id}").order("id desc").limit(1)

  if @find_summary!= nil and @find_summary!="" and @find_summary.size!=0
     @all_summary = Logtime.where("#{@search} and project_master_id = #{pro_id}")
     @sum_time = Logtime.where("#{@search} and project_master_id = #{pro_id}").sum(:task_time)
    @task_time = []
    @task_time_hour = []
    @all_summary.each do |as|
        @task_time << {'date'=>"#{as.task_date}", 'hour'=>as.task_time}    
  end
#@project_task_name = ProjectTask.find_by_id(@summary.task_master_id)
@project_master_id = ProjectMaster.find_by_id(pro_id)

resp = {
  
  'project_id'=>pro_id,
  'project_name' =>@project_master_id.project_name,
  'date'=>@task_time,
  'worked' => @sum_time

}  
  end
  end
end  
  render json: resp
end
=end

def edit_summary
  #begin
   @start_date = params[:start_date] 
      @end_date = params[:start_date].to_date.at_end_of_week
    


  @summary = Logtime.find_by_id(params[:id])
  resp = []
  @search="task_date between '#{@start_date}' and '#{@end_date}' and user_id=#{@summary.user_id}"
  @find_summary = Logtime.where("#{@search} and project_master_id = #{@summary.project_master_id}").order("id desc").limit(1)

  if @find_summary!= nil and @find_summary!="" and @find_summary.size!=0
 @all_summary = Logtime.where("#{@search} and project_master_id = #{@summary.project_master_id} and task_master_id=#{@summary.task_master_id} ")
 @sum_time = Logtime.where("#{@search} and project_master_id = #{@summary.project_master_id} and task_master_id=#{@summary.task_master_id} ").sum(:task_time)
@task_time = []
@task_time_hour = []
@all_summary.each do |as|
    @task_time << {'id' => as.id,'date'=>"#{as.task_date}", 'hour'=>as.task_time}    
end
@project_task_name = ProjectTask.find_by_id(@summary.task_master_id)
@project_master_id = ProjectMaster.find_by_id(@summary.project_master_id)
@client_id = Client.find_by_id(@project_master_id.client_id)
@sprint_planning_id = SprintPlanning.find_by_id(@summary.sprint_planning_id)
@release_planning_id = ReleasePlanning.find_by_id(@sprint_planning_id.release_planning_id)
@user_id = User.find_by_id(@summary.user_id)

 @holiday_all = Holiday.all.order(:date)
        @holiday_resp=[]
        @holiday_all.each do |h| 
           @holiday_resp << {
          'id' => h.id,
          'holiday' => h.date
        }
        end

resp = {
  'client_id' => @client_id.id ,
  'client_name' => @client_id.client_name,
  'project_id'=>@summary.project_master_id,
  'project_name' =>@project_master_id.project_name, 
  'sprint_id' => @sprint_planning_id.id, 
  'sprint_name' => @sprint_planning_id.sprint_name,
  'release_id'=> @sprint_planning_id.release_planning_id,
  'release_name'=>@release_planning_id.release_name,
  'resource_id' => @user_id.id,
  'resource_name' => @user_id.name,
  'task_id'=> @summary.task_master_id,
  'task_name'=>@project_task_name.task_name,
  'status' => @summary.status,
  'comments' => @summary.comments,
  'list_of_holidays' => @holiday_resp,
  'date'=>@task_time,
  'worked' => @sum_time

}
  
  end
  render json: resp
#rescue
#  render json: { valid: false, msg: "Invalid Parameters."} 
#end
  
end


def get_task_status
   @task_all = TaskStatusMaster.all.order(:status)
      @task_resp=[]
      @client_id = ""
      @task_all.each do |tsm| 

        @task_resp << {
         'id' => tsm.id,
         'status_name' => tsm.status      
        }
      end
      render json: @task_resp
end


def utilization_report
# Create a new Excel Workbook
date = Time.now.strftime("%m/%d/%Y")
date1 = Time.now.strftime("%m-%d-%Y")

@end_date = Date.today
@start_date = @end_date-5

@file_name = "Utilization_Report.xls"
workbook = WriteExcel.new("#{Rails.root}/#{@file_name}")

# Add worksheet(s)
worksheet1  = workbook.add_worksheet

# Add and define a format

format = workbook.add_format
format.set_bold
format.set_size(10)
format.set_bg_color('cyan')
format.set_color('black')
format.set_border(1)

format1 = workbook.add_format
format1.set_size(10)
format1.set_color('black')
format1.set_text_wrap(1)
format1.set_align('top')

worksheet1.set_column('A:A', 20,format1)
worksheet1.set_column('B:B', 25,format1)
worksheet1.set_column('C:C', 25,format1)
worksheet1.set_column('D:D', 25,format1)
worksheet1.set_column('E:E', 25,format1)
worksheet1.set_column('F:F', 25,format1)
worksheet1.set_column('G:G', 25,format1)
worksheet1.set_column('H:H', 25,format1)
worksheet1.set_column('I:I', 25,format1)
worksheet1.set_column('J:J', 25,format1)
worksheet1.set_column('K:K', 25,format1)
worksheet1.set_column('L:L', 25,format1)
worksheet1.set_column('M:M', 25,format1)

worksheet1.set_row(0,20)

# write a formatted and unformatted string.
worksheet1.write(0,0, 'No', format)
worksheet1.write(0,1, 'Team Member', format)
worksheet1.write(0,2, 'Team Name', format)
worksheet1.write(0,3, 'Start Date', format)
worksheet1.write(0,4, 'Project', format)
worksheet1.write(0,5, 'Status', format)
worksheet1.write(0,6, 'Weekly Hours', format)
worksheet1.write(0,7, 'Project category', format)
worksheet1.write(0,8, 'Unit', format)
worksheet1.write(0,9, 'Skill Set', format)
worksheet1.write(0,10, 'Account', format)
worksheet1.write(0,11, 'Emp Type', format)
worksheet1.write(0,12, 'Comments', format)

row=1
@user_all = User.all

@user_all.each do |u|
worksheet1.write(row,0, "#{u.employee_no}", format1)
worksheet1.write(row,1, "#{u.name}", format1)
@team = TeamMaster.find_by_id(u.team_id)
if @team != nil
  @team_name = @team.team_name
else
  @team_name = "-"
end
worksheet1.write(row,2, "#{@team_name}", format1)

@find_project_for_user = ProjectUser.where("user_id=#{u.id}")
@project_id = ""
@find_project_for_user.each do |pu|
if @project_id == ""
@project_id = pu.project_master_id
else
@project_id = @project_id.to_s+","+pu.project_master_id.to_s
end
end#@find_project_for_user.each do |pu|

if @project_id!=""
@project_all = ProjectMaster.where("id IN(#{@project_id})")
@pro_name=""
@project_all.each do |pro|
if @pro_name == ""
@pro_name = pro.project_name
else
@pro_name = @pro_name+", "+pro.project_name
end
end#@project_all.each do |pro|
else
  @pro_name="-"
end

worksheet1.write(row,4, "#{@pro_name}", format1)

@skill_set = UserTechnology.where("user_id = #{params[:user_id]}")
    @technology_name=""
    @skill_set.each do |tech|
tec = TechnologyMaster.find_by_id(tech.technology_master_id)
      if @technology_name == ""
      @technology_name = tec.technology
      else
      @technology_name = @technology_name+", "+tec.technology
      end
    end#@skill_set.each do |tec|
    if @technology_name != ""
      @tech_name = @technology_name
    else
      @tech_name = "-"
    end
    resp=[]
        resp << {
            'technology' => @tech_name
            }
            render json: resp

worksheet1.write(row,9, "#{@tech_name}", format1)

row += 1
end

workbook.close

#send_file("#{@file_name}" ,
  #    :filename     =>  "#{@file_name}",
  #    :charset      =>  'utf-8',
  #    :type         =>  'application/octet-stream')

end


def get_role_email
     @role_email=[]
     
    @users = User.where("role_master_id = #{params[:role_master_id]}")
      
      @users.each do |ue| 
        @role_email << {
         'id' => ue.id,
         'email' => ue.email      
        }        
      end
      render json: @role_email
end


=begin
  def get_manager
      manager_resp = []
      @role_masters = RoleMaster.where("role_name like '%PMO%' or role_name like '%PMANDBA% 'or role_name like '%BA%' or role_name like '%PM%'")
    @role_id=""
    @role_masters.each do |r|
    if @role_id==""
    @role_id = r.id
    else
    @role_id = @role_id.to_s+","+r.id.to_s
    end
    end

    if @role_id!=""
      @users = User.where("role_master_id IN(#{@role_id}) and active = 'active'").order(name: :asc)   
      @users.each do |m|
        @check_u = ProjectUser.where("user_id=#{m.id}")
        @u = []
         @check_u.each do |cu|
        @u << cu.utilization
      end     
       # if @u.sum.to_i < 100
        manager_resp << {
        'id' => m.id,
        'managers' => "#{m.name} #{m.last_name}"
      }
       end
    #end
  end
    render json: manager_resp
end
=end

  def get_manager
    manager_resp = []
    @manager = CronReporting.all.order(reporting_name: :asc)
    @manager.each do |m|
     manager_resp << {
        'id' => m.reporting_id,
        'managers' => m.reporting_name
      }
    end
    render json: manager_resp
  end

  def get_user
      manager_resp = []
      @role_masters = RoleMaster.where("role_name like '%PMO%' or role_name like '%PMANDBA% 'or role_name like '%BA%' or role_name like '%PM%'")
    @role_id=""
    @role_masters.each do |r|
    if @role_id==""
    @role_id = r.id
    else
    @role_id = @role_id.to_s+","+r.id.to_s
    end
    end

    if @role_id!=""
     # @users = User.where("role_master_id NOT IN(#{@role_id}) and active = 'active'").order(name: :asc)
     @users = User.where("active = 'active'").order(name: :asc)
      @users.each do |m|
        @check_u = ProjectUser.where("user_id=#{m.id}")
        @u = []
         @check_u.each do |cu|
        @u << cu.utilization
      end     
      if m.nickname!="" and m.nickname!=nil
        @name = m.nickname
      else
        @name = "#{m.name} #{m.last_name}"
      end
        #if @u.sum.to_i < 100
        manager_resp << {
        'id' => m.id,
        'users' => @name
        
      }
       end
    #end
  end
    render json: manager_resp
end


def task_completed
  @taskboard = Taskboard.find_by_id(params[:id])
  @taskboard.task_complete = 1
  @taskboard.save
      render json: { valid: true, success: 'Taskboard Accepted!' }, status: 200
end


def add_taskboard
  get_all_projects
  resp = {
        'project' => @project_resp
      }
  
      render json: resp
end

def get_task_user
   resp =  []
           
   @task_user = Taskboard.where("task_master_id = #{params[:task_master_id]}")
   @task_user.each do |p|    
   @task_users = User.find_by_id(p.task_master_id)  
   if @task_users  != nil
      resp << {
        'id' => @task_users.id,
        'resource_name' => @task_users.name
      }
    end
    end
      @task_user=[]
      @task_user << {
         'task_user' => resp        
        }
      render json: @task_user
end

def add_sprint
  get_all_projects
  get_all_sprint_status
  get_all_releases(params[:project_master_id])

  resp = []
  resp << {
        'project_list' => @project_resp,
        'sprint_list' => @sprint_status_resp,
        'release_list' => @release_resp
      }  
      render json: resp
end


def get_project_users
  role_resp =  []
   @role_masters = RoleMaster.all
   @role_masters.each do |r|      
      role_resp << {
        'id' => r.id,
        'role_name' => r.role_name,
      }
    end
   email_resp =  []
   @users = User.all
   @users.each do |u|   
      email_resp << {
        'id' => u.id,
        'email' => u.email
      }
    end 
   team_resp =  []
   @teams = TeamMaster.all
   @teams.each do |t|   
      team_resp << {
        'id' => t.id,
        'team_name' => t.team_name,
      }
    end
   proj_resp =  []
   @projects = ProjectMaster.all
   @projects.each do |p|   
      proj_resp << {
        'id' => p.id,
        'project_name' => p.project_name,
      }
    end    
  #search
        @search = ""
    if params[:role_master_id]!=nil and params[:role_master_id]!=""
      if @search == ""
        @search = "role_master_id = #{params[:role_master_id]}" 
      else
        @search = @search +  " and role_master_id = #{params[:role_master_id]}"  
      end  
    end

    if params[:email]!=nil and params[:email]!=""      
      if @search == ""
        @search = "id = #{params[:email]}" 
      else
        @search = @search + " and id = #{params[:email]}"  
      end  
    end

    if params[:team_master_id]!=nil and params[:team_master_id]!=""      
      if @search == ""
        @search = "team_id = #{params[:team_master_id]}" 
      else
        @search = @search + " and team_id = #{params[:team_master_id]}"  
      end  
    end    

    if params[:project_master_id]!=nil and params[:project_master_id]!=""      
      if @search == ""
        @search = "project_master_id = #{params[:project_master_id]}" 
      else
        @search = @search + " and project_master_id = #{params[:project_master_id]}"  
      end  
    end        
    #search
    puts  @search

   name_resp =  []
   @users = User.where(@search)
   @users.each do |u|   
      name_resp << {
        'id' => u.id,        
        'user_name' => "#{u.name} "+ "#{u.last_name}"
      }
    end
    resp = []
    resp << {
      'role_name' => role_resp,
      'email_id' => email_resp,
      'team' => team_resp,
      'project' => proj_resp,
      'users' => name_resp
    }
    render json: resp
end


def get_sprint   
   resp = []
    @sprint_plannings = SprintPlanning.where("project_master_id = #{params[:project_master_id]}")
    @sprint_plannings.each do |v|      
      resp << {
        'id' => v.id,
        'sprint_name' => v.sprint_name
      }
    end
    render json: resp
 end

def all_projects
  get_all_projects
  @respone = {
            'list' => @project_resp,
            'count' => @project_resp.count
          }
        render json: @respone
end

def get_task_project

 resp = []
    @project_task_mappings = ProjectTaskMapping.where("project_master_id = #{params[:project_master_id]} and user_id = #{params[:user_id]}")
    @project_task_mappings.each do |v|    
    @project_task_name = ProjectTask.find_by_id(v.project_task_id)

@sprint_plannings = SprintPlanning.where("project_master_id = #{params[:project_master_id]}")
    @sprint_plannings.each do |s|      
      resp << {
        'id' => s.id,
        'sprint_name' => s.sprint_name
      }
    end
      resp << {
        'id' => @project_task_name.id,
        'project_master_id' => v.project_master_id,
        'task_name' => @project_task_name.task_name
      }
    end
    render json: resp
end


   def get_client_project
      @project_all = ProjectMaster.where("client_id = #{params[:client_id]}")
      @client_project=[]
      @project_all.each do |p| 
        @client_project << {
         'id' => p.id,
         'project_name' => p.project_name      
        }
      end
      @client_project1=[]
      @client_project1 << {
         'client_project' => @client_project        
        }
      render json: @client_project1
   end

    def get_release
      resp =  []
       @release_plannings = ReleasePlanning.where("project_master_id = #{params[:project_master_id]}")
       @release_plannings.each do |r|      
          resp << {
            'id' => r.id,
            'release_name' => r.release_name
          }
        end
        @project_release=[]
          @project_release << {
             'project_release' => resp        
            }
          render json: @project_release
    end

    def get_release_sprint
      resp =  []
     @sprint_plannings = SprintPlanning.where("release_planning_id = #{params[:release_planning_id]}")
     @sprint_plannings.each do |s|      
        resp << {
          'id' => s.id,
          'sprint_name' => s.sprint_name
        }
      end
        @release_sprint=[]
        @release_sprint << {
           'release_sprint' => resp        
          }
        render json: @release_sprint
  end

  def get_sprint_task
        resp =  []
             
     @project_tasks = Taskboard.where("sprint_planning_id = #{params[:sprint_planning_id]}")
     @project_tasks.each do |p|    
     @project_ta = ProjectTask.find_by_id(p.task_master_id)  
     if @project_ta  != nil
        resp << {
          'id' => @project_ta.id,
          'task_name' => @project_ta.task_name
        }
      end
      end
        @sprint_task=[]
        @sprint_task << {
           'sprint_task' => resp        
          }
        render json: @sprint_task
  end


  def get_release_project(project_id)
  @resp_rel =  []

         @release_plannings = ReleasePlanning.where("project_master_id = #{project_id}")
         @release_plannings.each do |r|  
         get_sprint_release(project_id, r.id)
            @resp_rel << {
              'id' => r.id,
              'ReleaseName' => r.release_name,
              'Sprint' => @resp_sprint
            }
          end  
  end

  def get_sprint_release(project_id, release_id)
    get_release_project(project_id)
      puts "#{project_id}-------------#{release_id}"

     @resp_sprint =  []
       @sprint_plannings = SprintPlanning.where("project_master_id = #{project_id} and release_planning_id =#{release_id}")
       @sprint_plannings.each do |s|    
       get_task_release(s.id)  
          @resp_sprint << {
            'id' => s.id,
            'SprintName' => s.sprint_name,
            'Tasks' => @resp_task
          }
        end        
  end

  def get_task_release(sprint_id)
     @resp_task =  [] 
     
     #@project_tasks = Logtime.find_by_sql("select distinct task_master_id from logtimes where sprint_planning_id = #{sprint_id} #{session[:search_task]}")            
       @project_tasks = Taskboard.where("sprint_planning_id = #{sprint_id}")
       @project_tasks.each do |p|    
       @project_ta = ProjectTask.find_by_id(p.task_master_id)  
       if @project_ta  != nil
        timesheets_records(p.task_master_id, sprint_id)
          @resp_task << {
            'id' => @project_ta.id,
            'TaskName' => @project_ta.task_name,
            'Timesheet' => @task_time
          }
        end
        end
  end

#-----------------timesheets---
  def forget_password

     user = User.find_by(email: params[:email]) 
   
	if user
		success=1
		if params[:email] && params[:otp]
			 if user.otp!=nil and user.otp==params[:otp].to_i
			   #user.update_attribute(:password,params[:password])            
			   #user.otp = nil
			   #user.save
			   success=1          
			 else
			  success=0           
			 end 
		end#if params[:email] && params[:otp]

    if params[:email] && params[:password]
         user.update_attribute(:password,params[:password])            
         user.otp = nil
         user.save
         success=1          
    end

		if params[:password_reset] && params[:password_reset].to_i==1
		 @r = rand(9999).to_s.center(4, rand(3).to_s).to_i
		 user.update_attribute(:otp,@r)  
		 UserNotifier.forget_password_otp_send(user).deliver_now                 
		 success=1
		end#if params[:password_reset]      

	else#if user       
		success=0
	end#if user

if success==1
render json: { valid: true}, status: 200
else
render json: { valid: false, error:"404"}, status: 200
end

   end#def validate_user



def add_edit_user
      resp = []
      resp << {
        'company' => getcompany,
        'role' => getrole,
        'branch' => getbranch,
        'reporting_to' => getreporting_to,
        'team' => getteam,
        'technology' => gettech      
      }
     
    render json: resp
end
def add_new_client
    resp = []
    @client_sources = ClientSource.all.order(:id)
    @client_sources.each do |cs|
      resp << {
        'id' => cs.id,
        'client_source_name' => cs.source_name
              
      }
     end

     client_source = []
     client_source << {
      'source' => resp
     }
    render json: client_source
  end

def add_new_project
      resp = []
      
      resp << {
        'project_type' => getproject_type,
        'domain_name' => getdomain_name,
        'client_name' => getclient_name,
        'project_status' => getproject_status,
        'business' => getbusiness,
        'project_location' => getprojectlocation,
        'engagement_type' => getengagementtype,
        'project_payment' => getprojectpayment,
        'project_manager' => getmanager
            
      }
     
    render json: resp
end


private

def getmanager
  manager_resp = []
    @manager = CronReporting.all.order(reporting_name: :asc)
    @manager.each do |m|
     manager_resp << {
        'id' => m.reporting_id,
        'manager_name' => m.reporting_name
      }
    end
 manager_resp

=begin  
  resp = []
  @role_masters = RoleMaster.where("role_name like '%PMO%' or role_name like '%PMANDBA% 'or role_name like '%BA%' or role_name like '%PM%'")
    @role_id=""
    @role_masters.each do |r|
    if @role_id==""
    @role_id = r.id
    else
    @role_id = @role_id.to_s+","+r.id.to_s
    end
    end
    @value = User.where("role_master_id IN(#{@role_id}) and active = 'active'").order(name: :asc)

    @value.each do |v|      
      resp << {
        'id' => v.id,
        'manager_name' => "#{v.name} #{v.last_name}"
      }
    end
    resp
=end    
end

def getcompany
  resp = []
    @value = Company.where("active = 'active'").order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'company_name' => v.company_name
      }
    end
    resp
end

def getbusiness
  resp = []
    @value = BusinessUnit.where("active = 'active'").order("id")
    @value.each do |bu|      
      resp << {
        'id' => bu.id,
        'business_name' => bu.name
      }
    end
    resp
end

def getengagementtype
  resp = []
    @value = EngagementType.where("active = 'active'").order("id")
    @value.each do |et|      
      resp << {
        'id' => et.id,
        'engagement_name' => et.name
      }
    end
    resp
end

def getprojectpayment
  resp = []
    @value = ProjectPayment.where("active = 'active'").order("id")
    @value.each do |pp|      
      resp << {
        'id' => pp.id,
        'payment_name' => pp.name
      }
    end
    resp
end

def getprojectlocation
  resp = []
    @value = ProjectLocation.where("active = 'active'").order("id")
    @value.each do |pl|      
      resp << {
        'id' => pl.id,
        'location_name' => pl.name
      }
    end
    resp
end

def getrole
  resp = []
    @value = RoleMaster.where("active = 'active'").order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'role_name' => v.role_name
      }
    end
    resp
end

def getbranch
  resp = []
    @value = Branch.where("active = 'active'").order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'branch_name' => v.name
      }
    end
    resp
end

def getreporting_to
  resp = []
    @value = CronReporting.all.order(:reporting_name => 'asc')
    @value.each do |v|      
      resp << {
        'reporting_id' => v.reporting_id,
        'reporting_name' => v.reporting_name
        #'reporting_name' => "#{v.name} #{v.last_name}"
      }
    end
    resp
end

def getteam
  resp = []
    @value = TeamMaster.where("active = 'active'").order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'team_name' => v.team_name
      }
    end
    resp
end

def gettech
  resp = []
    @value = TechnologyMaster.where("active = 'active'").order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'technology_name' => v.technology
      }
    end
    resp
end



def getproject_type
  resp = []
    @value = ProjectType.where("active = 1").order("id")
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'project_type_name' => v.project_name
      }
    end
    resp
end

def getdomain_name
  resp = []
    @value = ProjectDomain.where("active = 1").order("id")
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'domain_name' => v.domain_name
      }
    end
    resp
end

def getclient_name
  resp = []
    @value = Client.where("active = 'active'").order("id")
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'client_name' => v.client_name
      }
    end
    resp
end

def getproject_status
  resp = []
    @value = ProjectStatusMaster.where("active = 1").order("id")
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'project_status' => v.status
      }
    end
    resp
end




end