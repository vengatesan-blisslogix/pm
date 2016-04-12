class Api::V1::ProjectUsersController < ApplicationController

before_action :authenticate_user!
before_action :set_project_user, only: [:show, :edit, :update]

 def index

get_all_projects
  if params[:project_id]!=nil and params[:project_id]!=""
@search = "project_master_id = #{params[:project_id]}"
  else
    if @project_all!=nil and @project_all.size!=0
@search = "project_master_id = #{@project_all[0].id}"
    else
@search = ""
    end
  end
	  @project_users = ProjectUser.where("#{@search}").page(params[:page])
	  resp=[]
     @project_users.each do |p| 
    
      if p.active.to_i==1
        @status=true
      else
        @status=false
      end
   @user_p = User.find_by_id(p.user_id)

   @role_user = RoleMaster.find_by_id(@user_p.role_master_id)
   if @role_user!=nil && @role_user!=""
        @role_name=@role_user.role_name
      else
        @role_name=""
      end
   @team_name = TeamMaster.find_by_id(@user_p.team_id)
   if @team_name!=nil && @team_name!=""
        @team_name=@team_name.team_name
      else
        @team_name=""
      end


      resp << {
        'id' => p.id,
        'first_name' => @user_p.name,
        'last_name' => @user_p.last_name,
        'email_id' => @user_p.email,
        'role' => @role_name,
        'team_name' => @team_name,
        'status' => @status
   
      }
      end

    pagination(ProjectUser,@search)
    
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'projects_list' => @project_resp,
      'project_users' => resp
    }

    render json: response
 end

def show	
   render json: @project
end

def create
 begin					
if params[:selected_user_id]!=nil and params[:selected_user_id]!=""
convert_param_to_array(params[:selected_user_id])
@s_user_id = @output_array
convert_param_to_array(params[:assigned_date])
@a_date = @output_array
convert_param_to_array(params[:relieved_date])
@r_date = @output_array
convert_param_to_array(params[:active])
@active = @output_array
convert_param_to_array(params[:utilization])
@utilization = @output_array
convert_param_to_array(params[:is_billable])
@billable = @output_array

     p=0
     @s_user_id.each do |user|
     	@project = ProjectUser.new
     	@project.assigned_date = @a_date[p]
     	@project.relieved_date = @r_date[p]
     	@project.active = @active[p]
     	@project.utilization = @utilization[p]
     	@project.is_billable = @billable[p]
     	@project.project_master_id = params[:project_master_id]
     	@project.user_id = user
     	@project.save!
       p=p+1
     end
     
 render json: { valid: true, msg:"created successfully."}
      else
        render json: { valid: false, error: "Invalid parameters" }, status: 404
    end
    rescue
    	render json: { valid: false, error: "Invalid parameters" }, status: 404
    end    
end

 def update   

    if @project.update(project_params)  	      
       render json: { valid: true, msg:"#{@project.task_name} created successfully."}
     else
        render json: { valid: false, error: @project.errors }, status: 404
     end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_project_user
      @project = ProjectUser.find_by_id(params[:id])
      if @project
      else
      	render json: { valid: false}, status: 404
      end
    end	
end
