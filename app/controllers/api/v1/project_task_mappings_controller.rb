class Api::V1::ProjectTaskMappingsController < ApplicationController

before_action :authenticate_user!
before_action :set_task_mapping, only: [:show, :edit, :update]

 def index
	if params[:page] && params[:per]
	  @task_mappings = ProjectTaskMapping.page(params[:page]).per(params[:per])
	else
	  @task_mappings = ProjectTaskMapping.limit(10)
	end
	  render json: @task_mappings  
 end

def show	
   render json: @task_mapping
end

def create

    @task_mapping = ProjectTaskMapping.new(task_mapping_params)
    if @task_mapping.save
    	index
     else
        render json: { valid: false, error: @task_mapping.errors }, status: 404
     end
    
end

 def update   

    if @task_mapping.update(task_mapping_params)  	      
       render json: @task_mapping
     else
        render json: { valid: false, error: @task_mapping.errors }, status: 404
     end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_task_mapping
      @task_mapping = ProjectTaskMapping.find_by_id(params[:id])
      if @task_mapping
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def task_mapping_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :assign_date => "#{params[:assign_date]}", :completed_date => "#{params[:completed_date]}", :active => "#{params[:active]}",  :priority => "#{params[:priority]}", :planned_duration => "#{params[:planned_duration]}",  :actual_duration => "#{params[:actual_duration]}", :assigned_by => "#{params[:assigned_by]}", :sprint_planning_id => "#{params[:sprint_planning_id]}",:task_status_id => "#{params[:task_status_id]}", :project_task_id => "#{params[:project_task_id]}", :project_id => "#{params[:project_id]}", :release_id => "#{params[:release_id]}", :user_id => "#{params[:user_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:assign_date, :completed_date, :active, :priority, :planned_duration, :actual_duration, :assigned_by, :sprint_planning_id, :task_status_id, :project_task_id, :project_id, :release_id, :user_id)
    
    end

end
