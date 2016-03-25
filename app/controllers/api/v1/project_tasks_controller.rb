class Api::V1::ProjectTasksController < ApplicationController

before_action :authenticate_user!
before_action :set_project, only: [:show, :edit, :update]

 def index
	if params[:page] && params[:per]
	  @projects = ProjectTask.page(params[:page]).per(params[:per])
	else
	  @projects = ProjectTask.limit(10)
	end
	  render json: @projects  
 end

def show	
   render json: @project
end

def create

    @project = ProjectTask.new(project_params)
    if @project.save
    	index
     else
        render json: { valid: false, error: @project.errors }, status: 404
     end
    
end

 def update   

    if @project.update(project_params)  	      
       render json: @project
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

      raw_parameters = { :task_name => "#{params[:task_name]}", :task_description => "#{params[:task_description]}", :active => "#{params[:active]}",  :priority => "#{params[:priority]}",  :planned_duration => "#{params[:planned_duration]}",  :actual_duration => "#{params[:actual_duration]}", :project_id => "#{params[:project_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:task_name, :task_description, :active, :priority, :planned_duration, :actual_duration, :project_id)
    
    end


end
