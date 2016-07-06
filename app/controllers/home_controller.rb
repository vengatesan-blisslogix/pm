class HomeController < ApplicationController
  def index
    @project_masters = ProjectMaster.all
  end

  def add_menus
    #add admin sub activity
    href = ["home.holidays","home.project_domains","home.project_status_masters","home.task_status_master"]
    icon = ["fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer", "fa fa-fw fa-tachometer"]
    i = 0
    admin = ActivityMaster.find_by_activity_Name("Admin")
    ["Holidays", "ProjectDomains", "ProjectStatusMaster", "TaskStatusMaster"].each do |ad|
    ad = ActivityMaster.create(activity_Name: "#{ad}", active: "active",  is_page: "yes", parent_id: admin.id, href: href[i],  icon: icon[i])
    RoleActivityMapping.create(role_master_id: 1, activity_master_id: ad.id, access_value: 1, user_id: 1, active: 1)
    i = i+1
    end
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