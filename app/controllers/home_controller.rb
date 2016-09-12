class HomeController < ApplicationController
  def index
    @project_masters = ProjectMaster.all
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


worksheet1.set_row(4,20)

# write a formatted and unformatted string.
worksheet1.write(4,0, 'No', format)
worksheet1.write(4,1, 'User Name', format)
worksheet1.write(4,2, 'Project Name', format)
worksheet1.write(4,3, 'Sprint Name', format)
worksheet1.write(4,4, 'Billable hour', format)
worksheet1.write(4,5, 'Non-Billable hour', format)
worksheet1.write(4,6, 'Total hour', format)


row=5
serial=1

  @users=User.all
  @users.each do |u|
    worksheet1.write(row,0, serial, format1)
    worksheet1.write(row,1, "#{u.name}#{u.last_name}", format1)

      @project_user = ProjectUser.where("user_id = #{u.id}")

        @project_user.each do |pu|
          @project_name = ProjectMaster.find_by_id(pu.project_master_id)
            worksheet1.write(row,2, "#{@project_name.project_name}", format1)
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


            @timesheet_summ_user_time = Logtime.where("sprint_planning_id=#{sp.id} and project_master_id=#{pu.id} and user_id=#{pu.user_id}").sum(:task_time)
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




  def add_menus

    #add admin sub activity
    href = ["home.timesheets" ]
    icon = ["fa fa-fw fa-tachometer"]
    i = 0
    admin = ActivityMaster.find_by_activity_Name("Admin")
    ["Timesheets"].each do |ad|
    ad = ActivityMaster.create(activity_Name: "#{ad}", active: "active",  is_page: "yes", parent_id: admin.id, href: href[i],  icon: icon[i])
    RoleActivityMapping.create(role_master_id: 1, activity_master_id: ad.id, access_value: 1, user_id: 1, active: 1)
    i = i+1
    end
  

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

def timesheet_approval
#@assigns = Logtime.find_by_id(params[:id])
@assigns_val = Logtime.where("project_master_id=#{params[:project_master_id]} and approved_by IS NULL")
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

  @start_date = Date.today.at_beginning_of_week
  @end_date =  @start_date + 5

@role_masters = RoleMaster.where("role_name like '%PMO%' or role_name like '%PM AND BA% 'or role_name like '%BA%' or role_name like '%PM%'")
    @role_id=[]
    @role_masters.each do |r|   
    @role_id << r.id    
    end

puts "*****************#{@role_id}********#{current_user.role_master_id}*****",@role_id.include?(current_user.role_master_id)

if current_user.role_master_id == 1 
  @search="task_date between '#{@start_date}' and '#{@end_date}'"
elsif @role_id.include?(current_user.role_master_id)
@find_reporting_to = User.where("reporting_to='#{current_user.id}'")
  @ruser=""
  @find_reporting_to.each do |ru|
    if @ruser==""
    @ruser=ru.id.to_s
    else
      @ruser=@ruser+","+ru.id.to_s
    end
  end
  if @ruser==""
    @search="task_date between '#{@start_date}' and '#{@end_date}' and user_id=#{params[:user_id]} and  id IN(0)"
  else
   @search="task_date between '#{@start_date}' and '#{@end_date}' and user_id IN (#{@ruser})"
  end
else
  @search="task_date between '#{@start_date}' and '#{@end_date}' and user_id=#{params[:user_id]}"
  
 
end

    @timesheet_summ = Logtime.where("#{@search}").select(:project_master_id).uniq
    resp = []    
 @timesheet_summ.each do |lts|
  if lts.project_master_id!=nil  and  lts.project_master_id!=""
  @project_name = ProjectMaster.find_by_id(lts.project_master_id)
      if @project_name != nil
        @proj_name = @project_name.project_name
      else
        @proj_name = ""
      end
@timesheet_summ_user = Logtime.where("#{@search} and project_master_id=#{lts.project_master_id}").select(:user_id).uniq
@timesheet_summ_user.each do |tsu|
@timesheet_summ_user_time = Logtime.where("#{@search} and project_master_id=#{lts.project_master_id} and user_id=#{tsu.user_id}").sum(:task_time)
@timesheet_summ_id = Logtime.where("#{@search} and project_master_id=#{lts.project_master_id} and user_id=#{tsu.user_id}")
      @resource_name = User.find_by_id(tsu.user_id)
      if @resource_name != nil
        @res_name = @resource_name.name
      else
        @res_name = ""
      end

@task_na = ProjectTask.find_by_id(@timesheet_summ_id[0].task_master_id)
      if @task_na != nil
        @task_name = @task_na.task_name
      else
        @task_name = ""
      end

 if @timesheet_summ_id[0].status != nil
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
end#@timesheet_summ.each do |lts|

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


def edit_summary
  #begin
  @start_date = Date.today.at_beginning_of_week
  @end_date =  @start_date + 5


  @summary = Logtime.find_by_id(params[:id])
  resp = []
  @search="task_date between '#{@start_date}' and '#{@end_date}' and user_id=#{@summary.user_id}"
  @find_summary = Logtime.where("#{@search} and project_master_id = #{@summary.project_master_id}").order("id desc").limit(1)

  if @find_summary!= nil and @find_summary!="" and @find_summary.size!=0
 @all_summary = Logtime.where("#{@search} and project_master_id = #{@summary.project_master_id}")
 @sum_time = Logtime.where("#{@search} and project_master_id = #{@summary.project_master_id}").sum(:task_time)
@task_time = []
@task_time_hour = []
@all_summary.each do |as|
    @task_time << {'date'=>"#{as.task_date}", 'hour'=>as.task_time}    
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
      @users = User.where("role_master_id IN(#{@role_id}) and active = 'active'")     
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
      @users = User.where("role_master_id NOT IN(#{@role_id}) and active = 'active'")
      @users.each do |m|
        @check_u = ProjectUser.where("user_id=#{m.id}")
        @u = []
         @check_u.each do |cu|
        @u << cu.utilization
      end     
        #if @u.sum.to_i < 100
        manager_resp << {
        'id' => m.id,
        'users' => "#{m.name} #{m.last_name}"
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
  render json: @project_resp
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
        'project_payment' => getprojectpayment
            
      }
     
    render json: resp
end


private

def getcompany
  resp = []
    @value = Company.all.order(:id)
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
    @value = BusinessUnit.all.order(:id)
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
    @value = EngagementType.all.order(:id)
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
    @value = ProjectPayment.all.order(:id)
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
    @value = ProjectLocation.all.order(:id)
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
    @value = RoleMaster.all.order(:id)
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
    @value = Branch.all.order(:id)
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
    @value = User.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'reporting_name' => v.name
      }
    end
    resp
end

def getteam
  resp = []
    @value = TeamMaster.all.order(:id)
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
    @value = TechnologyMaster.all.order(:id)
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
    @value = ProjectType.all.order(:id)
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
    @value = ProjectDomain.all.order(:id)
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
    @value = Client.all.order(:id)
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
    @value = ProjectStatusMaster.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'project_status' => v.status
      }
    end
    resp
end




end