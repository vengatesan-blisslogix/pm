class Api::V1::ProjectTaskMappingsController < ApplicationController

before_action :authenticate_user!
before_action :set_task_mapping, only: [:show, :edit, :update]

 def index
   @project_task_mappings = ProjectTaskMapping.page(params[:page])
    resp=[]
     @project_task_mappings.each do |p| 
    
      if p.active.to_i==1
        @status=true
      else
        @status=false
      end
      @project_task = ProjectTask.find_by_id(p.project_task_id)
      if @project_task!=nil and @project_task!=""
        @task_name =@project_task.task_name
      else
        @task_name =""
      end
      resp << {
        'id' => p.id,
        'task_name' => @task_name,
        'assign_date' => p.assign_date,
        'completed_date' => p.completed_date,        
        'actual_duration' => p.actual_duration,
        'assigned_by' => p.assigned_by,          
        'active' => p.active,
        'priority' => p.priority,
        'status' => @status        
      }
      end
   @search=""
    pagination(ProjectTaskMapping,@search)
    
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'project_tasks' => resp
    }

    render json: response
 end

def show	
   render json: @project_task_mapping
end

def create

    @project_task_mapping = ProjectTaskMapping.new(task_mapping_params)
    if @project_task_mapping.save
    	index
     else
        render json: { valid: false, error: @project_task_mapping.errors }, status: 404
     end
    
end

 def update   

    if @project_task_mapping.update(task_mapping_params)  	      
       render json: @project_task_mapping
     else
        render json: { valid: false, error: @project_task_mapping.errors }, status: 404
     end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_task_mapping
      @project_task_mapping = ProjectTaskMapping.find_by_id(params[:id])
      if @project_task_mapping
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def task_mapping_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :assign_date => "#{params[:assign_date]}", :completed_date => "#{params[:completed_date]}", :active => "#{params[:active]}",  :priority => "#{params[:priority]}", :planned_duration => "#{params[:planned_duration]}",  :actual_duration => "#{params[:actual_duration]}", :assigned_by => "#{params[:assigned_by]}", :sprint_planning_id => "#{params[:sprint_planning_id]}", :task_status_master_id => "#{params[:task_status_master_id]}", :project_task_id => "#{params[:project_task_id]}", :project_id => "#{params[:project_master_id]}", :release_planning_id => "#{params[:release_planning_id]}", :user_id => "#{params[:user_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:assign_date, :completed_date, :active, :priority, :planned_duration, :actual_duration, :assigned_by, :sprint_planning_id, :task_status_master_id, :project_task_id, :project_master_id, :release_planning_id, :user_id)
    
    end

end
