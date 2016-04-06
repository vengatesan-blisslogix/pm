class Api::V1::TodotasklistsController < ApplicationController

	before_action :set_task, only: [:show, :edit, :update]
  before_action :authenticate_user!


 def index
  
    #@tasks = Todotasklist.where("created_by_user=#{params[:user_id]}").page(params[:page]).order(:id)    
@tasks = Todotasklist.where("created_by_user=#{params[:user_id]}")
     resp=[]      
		@tasks.each do |t| 
			if t.status.to_i==1
			@status=true
			else
			@status=false
			end
			resp << {
			'id' => t.id,
			'role_name' => t.task_name,
			'status' => @status
			}
		end

    pagination(Todotasklist)
    
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'tasks' => resp
    }

    render json: response
    
 end

def show	
  resp=[]
     resp << {
        'id' => @task.id,
        'role_name' => @task.role_name,
        'description' => @task.description,
        'activity' => getaccess(@task.id)
      }
      render json: resp
end

def create

    @task = Todotasklist.new(todotasklist_params)
    if @task.save
      render json: { valid: true, msg:"#{@task.task_name} created successfully."}
     else
      render json: { valid: false, msg: @task.errors }, status: 404
     end
    
end

 def update   
 
    if @task.update(todotasklist_params)
      if params[:activity_id] && params[:activity_id]!=""
        params[:activity_id] = params[:activity_id].gsub('"',"")
    	@all_activity = ActivityMaster.where("id IN (#{params[:activity_id]})")
      RoleActivityMapping.destroy_all(:role_master_id => @task.id)
        @all_activity.each do |act|
    	RoleActivityMapping.create(role_master_id: @task.id, activity_master_id: act.id, access_value: 1, user_id: current_user.id)
        end  
        end  

       render json: { valid: true, msg:"#{@task.role_name} updated successfully."}
     else
        render json: { valid: false, msg: @task.errors }, status: 404
     end
  end
private

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Todotasklist.find_by_id(params[:id])
      if @task
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def todotasklist_params
     # params.require(:role_master).permit(:role_name)
     raw_parameters = { :task_name => "#{params[:task_name]}", :created_by_user => "#{params[:created_by_user]}", :status=> 1 }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:task_name, :created_by_user, :status)
    end
   

end
