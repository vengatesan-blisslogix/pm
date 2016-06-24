class Api::V1::ProjectUsersController < ApplicationController

before_action :authenticate_user!
before_action :set_project_user, only: [:show, :edit, :update]

 def index
   get_all_projects

if params[:project_master_id] and params[:client_id]
@search = "project_master_id=#{params[:project_master_id]} and client_id=#{params[:client_id]} and user_id!=0"

elsif params[:project_master_id]
@search = "project_master_id=#{params[:project_master_id]}" 

elsif params[:client_id]
@search = "client_id=#{params[:client_id]}"

else
@search = "user_id!=0"
end   

  @project_users = ProjectUser.where("#{@search}")

if @project_users!=nil and @project_users.size!=0
@pro_id = []
@project_users.each do |pu|
  @pro_id << pu.project_master_id
end
@pro_id=@pro_id.uniq
@project_id = ""
@pro_id.each do |pr|
if @project_id==""
@project_id = pr
else
@project_id = @project_id.to_s+","+pr.to_s
end
end
if @project_id!=""
@search_value ="id IN(#{@project_id})" 
else
  @search_value ="id IN(0)"
  end
else
@search_value ="id IN(0)"
end

@project_master = ProjectMaster.where(@search_value).page(params[:page]).order(:id)
  resp=[]
   @project_master.each do |p|


            @project_name =p.project_name
            @clients = Client.find_by_id(p.client_id)
            if @clients!=nil and @clients!=""
              @client_name   =@clients.client_name 
            else
              @client_name   =""
            end
        
        

      resp << {
        'id' => p.id,
        'project_name' => @project_name,
        'assigned_date' => p.start_date,        
        'relieved_date' => p.end_date,
        'status' => p.active
      }
      end
  
    pagination(ProjectMaster,@search_value)
    get_all_clients
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'clients' => @client_resp,
      'project_users' => resp
    }
    render json: response
 end

def show  
   render json: @project_user
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
      @project.client_id = params[:client_id]
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

     if @project_user.update(project_params)                       
       render json: { valid: true, msg:"Project updated successfully."}
     else
        render json: { valid: false, error: @project_user.errors }, status: 404
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
             :user_id => "#{params[:user_id]}",
             :client_id => "#{params[:client_id]}"
            }
            parameters = ActionController::Parameters.new(raw_parameters)
            parameters.permit(:project_type_id, :assigned_date, :relieved_date, :active, :utilization, :is_billable, :project_master_id, :user_id, :client_id)
    end 
end
