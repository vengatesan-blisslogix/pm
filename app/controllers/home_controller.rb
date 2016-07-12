class HomeController < ApplicationController
  def index
    @project_masters = ProjectMaster.all
  end

  def add_menus

    #add admin sub activity
    href = ["home.timesheet_summary","home.timesheet_approval"]
    icon = ["fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer"]
    i = 0
    admin = ActivityMaster.find_by_activity_Name("Admin")
    ["TimesheetSummary", "TimesheetApproval"].each do |ad|
    ad = ActivityMaster.create(activity_Name: "#{ad}", active: "active",  is_page: "yes", parent_id: admin.id, href: href[i],  icon: icon[i])
    RoleActivityMapping.create(role_master_id: 1, activity_master_id: ad.id, access_value: 1, user_id: 1, active: 1)
    i = i+1
    end
  end
=begin
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
=end


def timesheet_summary
  
  @timesheet_summ = Logtime.where("user_id = #{params[:user_id]}").page(params[:page]).order(:created_at => 'desc')
  resp = []
  @timesheet_summ.each do |ts| 
    @project_name = ProjectMaster.find_by_id(ts.project_master_id)
    if @project_name != nil
      @proj_name = @project_name.project_name
    else
      @proj_name = ""
    end

    @resource_name = User.find_by_id(ts.user_id)
    if @resource_name != nil
      @res_name = @resource_name.name
    else
      @res_name = ""
    end

    if ts.status != nil
      @status = ts.status
    else
      @status = "pending"
    end

    if ts.comments != nil
      @comments = ts.comments
    else
      @comments = ""
    end

    pagination(Logtime,@search)

      resp << {
        'id' => ts.id,
        'project_name' => @proj_name,
        'resource_name' => @res_name,
        'date' => ts.date,
        'no_of_hours' => ts.task_time,
        'status' => @status,
        'comments' => @comments
      }

      end            
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'timesheet_summary' => resp

    }
  render json: response 
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

@skill_set = TechnologyMaster.where("user_id = #{u.id}")
@technology_name=""
@skill_set.each do |tec|
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
      @users = User.where("role_master_id IN(#{@role_id})")     
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
      @users = User.where("role_master_id NOT IN(#{@role_id})")
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


def add_taskboard
  get_all_projects
  get_project_sprint(params[:project_master_id])
  resp = []
  resp << {
        'project_list' => @project_resp,
        'project_sprint'  => @project_sprint_resp
      }
  
      render json: resp
end

def get_release_sprint
    resp =  []
   @sprint_plannings = SprintPlanning.where("release_planning_id = #{params[:release_planning_id]}")
   @sprint_plannings.each do |s|      
      resp << {
        'id' => s.project_master_id,
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
   @project_tasks = ProjectTask.where("project_master_id = #{params[:sprint_planning_id]}")
   @project_tasks.each do |p|      
      resp << {
        'id' => p.id,
        'task_name' => p.task_name
      }
    end
      @sprint_task=[]
      @sprint_task << {
         'sprint_task' => resp        
        }
      render json: @sprint_task
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
    @project_task_mappings = ProjectTaskMapping.where("project_master_id = #{params[:project_master_id]}")
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
        'project_status' => getproject_status
            
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