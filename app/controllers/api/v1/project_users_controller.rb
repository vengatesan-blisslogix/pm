class Api::V1::ProjectUsersController < ApplicationController

before_action :authenticate_user!
before_action :set_project_user, only: [ :edit]

 def index
   get_all_projects
  
  #search
  if params[:client_id]!=nil and params[:client_id].length.to_i!=0 and params[:client_id]!= "undefined"
    @search_client ="client_id = #{params[:client_id]}"
  else
    @search_client =""
  end
#  puts "-----#{params[:project_master_id].strip.length}-------"
  if params[:project_master_id]!=nil and params[:project_master_id].length.to_i!=0 and params[:project_master_id]!= "undefined"
    @search_word ="project_master_id = #{params[:project_master_id]}"
  else
    @search_word =""
  end
  if @search_client != "" and @search_word != ""
    @search = "#{@search_client} and #{@search_word}"
  elsif @search_client != ""
    @search = "#{@search_client}"
  elsif @search_word !=""
    @search = "#{@search_word}"
  else
    @search = ""
  end

@find_user = User.find_by_id(params[:user_id])
  if @find_user and @find_user
    
  end
  #search
  @project_users = ProjectUser.where("#{@search}").order(:created_at => 'desc')

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

@project_master = ProjectMaster.where(@search_value).page(params[:page]).order(:created_at => 'desc')
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
        'status' => p.active,
        'is_billable' => p.billable
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
   #render json: @project_user
   @project_master = ProjectMaster.find_by_id(params[:id])
   if @project_master != nil

     @find_pro_user_manager = ProjectUser.where("project_master_id = #{@project_master.id} and manager = 1")

     manager_resp = []
     @find_pro_user_manager.each do |m|
if m.user_id != nil

    @time_sheets = Logtime.where("project_master_id = #{@project_master.id} and user_id = #{m.user_id}")

    if @time_sheets != nil and @time_sheets.size.to_i >= 1
      @flag =  1
    else
      @flag = 0
    end
  else
    @flag = 0
  end

     manager_resp << {
        'id' => m.id,
        'manager_id' => m.user_id,
        'assigned_date'  =>m.assigned_date,
        'relieved_date'  => m.relieved_date,
        'status'  => m.active,
        'utilization'  => m.utilization,
        'is_billable'  => m.is_billable,
        'flag' => @flag
      }
    end

     @find_pro_user = ProjectUser.where("project_master_id = #{@project_master.id} and manager = 0")

     user_resp = []
     @find_pro_user.each do |m|
if m.user_id != nil
     @time_sheets = Logtime.where("project_master_id = #{@project_master.id} and user_id = #{m.user_id}")
     
    if @time_sheets != nil and @time_sheets.size.to_i >= 1
      @flag =  1
    else
      @flag = 0
    end
  else
    @flag = 0
  end   
     user_resp << {
        'id' => m.id,
        'user_id' => m.user_id,
        'assigned_date'  =>m.assigned_date,
        'relieved_date'  => m.relieved_date,
        'status'  => m.active,
        'utilization'  => m.utilization,        
        'is_billable'  => m.is_billable,
        'flag' => @flag
      }
    end
   else
   end

   response = {
     'client_id' => @project_master.client_id,
     'project_id' => @project_master.id,
     'start_date' => @project_master.start_date,
     'end_date' => @project_master.end_date,
     'manager_resp' => manager_resp,
     'project_users' => user_resp
    }
    render json: response
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
convert_param_to_array(params[:manager])
@manager = @output_array


     p=0
     @s_user_id.each do |user|
      @project = ProjectUser.new
      @project.assigned_date = @a_date[p]
      @project.relieved_date = @r_date[p]
      @project.active = 'active'
      @project.utilization = @utilization[p]
      @project.is_billable = @billable[p]
      @project.project_master_id = params[:project_master_id]
      @project.user_id = user
      @project.client_id = params[:client_id]
      @project.manager = @manager[p]
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
convert_param_to_array(params[:manager])
@manager = @output_array

     p=0
     @s_user_id.each do |user|
      @find_pro_user = ProjectUser.where("project_master_id = #{params[:project_master_id]} and user_id = #{user}")

      if @find_pro_user != nil and @find_pro_user.size !=0
         @project = ProjectUser.find_by_id(@find_pro_user[0].id)
      else
         @project = ProjectUser.new
      end     

      @project.assigned_date = @a_date[p]
      @project.relieved_date = @r_date[p]
      @project.active = @active[p]
      @project.utilization = @utilization[p]
      @project.is_billable = @billable[p]
      @project.project_master_id = params[:project_master_id]
      @project.user_id = user
      @project.client_id = params[:client_id]
      @project.manager = @manager[p]
      @project.save!
       p=p+1
     end
     
        render json: { valid: true, msg:"updated successfully."}
      else
        render json: { valid: false, error: "Invalid parameters" }, status: 404
    end
    rescue
      render json: { valid: false, error: "Invalid parameters" }, status: 404
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
