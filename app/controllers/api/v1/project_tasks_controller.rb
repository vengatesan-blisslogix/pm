class Api::V1::ProjectTasksController < ApplicationController

before_action :authenticate_user!
before_action :set_project, only: [:show, :edit, :update]

 def index

  get_all_projects

      if params[:project_master_id] 
        @search = "project_master_id = #{params[:project_master_id]}"
      else
        @search = ""
      end

	  @project_tasks = ProjectTask.where(@search).page(params[:page])
	  resp=[]
     @project_tasks.each do |p| 
  


      @project_master = ProjectMaster.find_by_id(p.project_master_id)
      if @project_master!=nil and @project_master!=""
        @project_name =@project_master.project_name
      else
        @project_name =""
      end      

    #@release_planning = ReleasePlanning.find_by_id(p.release_planning_id)
    #if @release_planning!=nil and @release_planning!=""
     # @release_name =@release_planning.release_name
    #else
     # @release_name =""
    #end


      resp << {
        'id' => p.id,
        'project_name' => @project_name,
        #'release_name' => @release_name,
        'task_name' => p.task_name,        
        'description' => p.task_description,
        'status' => @status,
        'priority' => p.priority,
        'planned_duration' => p.planned_duration
      }
      end
   @search=""
    pagination(ProjectTask,@search)
    
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'project_list' => @project_resp,
      'project_tasks' => resp
    }

    render json: response
 end

def show	
   render json: @project
end

def create

    @project = ProjectTask.new(project_params)
    if @project.save
          @project.active = "active"
        @project.save
    	render json: { valid: true, msg:"#{@project.task_name} created successfully."}
     else
        render json: { valid: false, error: @project.errors }, status: 404
     end
    
end

 def update   

    if @project.update(project_params)  	      
       render json: { valid: true, msg:"#{@project.task_name} updated successfully."}
     else
        render json: { valid: false, error: @project.errors }, status: 404
     end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = ProjectTask.find_by_id(params[:id])
      if @project
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :task_name => "#{params[:task_name]}", :task_description => "#{params[:task_description]}", :active => "#{params[:active]}",  :priority => "#{params[:priority]}",  :planned_duration => "#{params[:planned_duration]}",  :actual_duration => "#{params[:actual_duration]}", :project_master_id => "#{params[:project_master_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:task_name, :task_description, :active, :priority, :planned_duration, :actual_duration, :project_master_id)
    
    end


end
