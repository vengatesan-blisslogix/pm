class Api::V1::ProjectUsersController < ApplicationController

before_action :authenticate_user!
before_action :set_project_user, only: [:show, :edit, :update]

 def index

   get_all_projects


if params[:project_master_id]
  @search = "project_master_id=#{params[:project_master_id]} and user_id!=0"
else
  @search = "project_master_id=#{@project_all[0].id} and user_id!=0"
end   
    @project_users = ProjectUser.where("#{@search}").page(params[:page]).order(:id)
    resp=[]
     @project_users.each do |p|      
     

      @user = User.find_by_id(p.user_id)
      if @user!=nil and @user!=""
        @email = @user.email
        @first_name = @user.name
        @last_name = @user.last_name


          @project_master = ProjectMaster.find_by_id(p.project_master_id)
          if @project_master!=nil and @project_master!=""
            @project_name =@project_master.project_name
          else
            @project_name =""
          end


          @role_master = RoleMaster.find_by_id(@user.role_master_id)
          if @role_master!=nil and @role_master!=""
            @role_name =@role_master.role_name
          else
            @role_name =""
          end

          @team_master = TeamMaster.find_by_id(@user.team_id)
          if @team_master!=nil and @team_master!=""
            @team_name =@team_master.team_name
          else
            @team_name =""
          end


      else
        @email =""
        @role_name =""
         @team_name =""
      end

      

      resp << {
        'id' => p.id,
        'role_name' => @role_name,
        'email' => @email,
        'project_name' => @project_name,
        'team_name' => @team_name,
        'first_name' => @first_name,
        'last_name' => @last_name,
        'assigned_date' => p.assigned_date,        
        'relieved_date' => p.relieved_date,
        'status' => p.active,
        'utilization' => p.utilization,
        'is_billable' => p.is_billable
      }
      end

  
    pagination(ProjectUser,@search)
    
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'projects' =>@project_resp,
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
       render json: { valid: true, msg:"Project created successfully."}
     else
        render json: { valid: false, error: @project.errors }, status: 404
     end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_project_user
      @project_user = ProjectUser.find_by_id(params[:id])
      if @project_user
      else
        render json: { valid: false}, status: 404
      end
    end

    def project_params
      raw_parameters = {            
             :assigned_date => "#{params[:assigned_date]}",
             :relieved_date => "#{params[:relieved_date]}",
             :active => "#{params[:active]}",
             :utilization => "#{params[:utilization]}",
             :is_billable => "#{params[:is_billable]}",
             :project_master_id => "#{params[:project_master_id]}",
             :user_id => "#{params[:user_id]}"
            }
            parameters = ActionController::Parameters.new(raw_parameters)
            parameters.permit(:project_type_id, :assigned_date, :relieved_date, :active, :utilization, :is_billable, :project_master_id, :user_id)
    end 
end
