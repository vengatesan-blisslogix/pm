class Api::V1::TasksController < ApplicationController


before_action :authenticate_user!
before_action :set_task, only: [:show, :edit, :update]

	def index 
      get_all_projects

    if current_user.role_master_id==1
	    @tasks = Task.where("project_id = #{params[:project_id]}").order(:created_at => 'desc')            
    else
      @tasks = Task.where("project_id = #{params[:project_id]}").order(:created_at => 'desc')
    end
    
	    resp=[]
	      @tasks.each do |t| 
	      	@project_master = ProjectMaster.find_by_id(t.project_id)
            if @project_master!=nil and @project_master!=""
              @project_name =@project_master.project_name
            else
              @project_name =""
            end

            @release = Release.find_by_id(t.release_id)
            if @release!=nil and @release!=""
              @release_name =@release.name
            else
              @release_name =""
            end

            @sprint = Sprint.find_by_id(t.sprint_id)
            if @sprint!=nil and @sprint!=""
              @sprint_name =@sprint.name
            else
              @sprint_name =""
            end

            @board = ProjectBoard.find_by_id(t.project_board_id)
            if @board!=nil and @board!=""
              @project_board_status =@board.status
            else
              @project_board_status =""
            end

            @priority = TaskPriority.find_by_id(t.task_priority_id)
            if @priority!=nil and @priority!=""
              @priority_name =@priority.name
            else
              @priority_name =""
            end

            @assignee = User.find_by_id(t.assignee_id)
            if @assignee!=nil and @assignee!=""
              @assignee_name =@assignee.name
            else
              @assignee_name =""
            end

            @assigner = User.find_by_id(t.assigner_id)
            if @assigner!=nil and @assigner!=""
              @assigner_name =@assigner.name
            else
              @assigner_name =""
            end
		    resp << {
			    'id' => t.id,
			    'name' => t.name,			    
			    'description' => t.description,
			    'p_hours' => t.p_hours,
			    'c_hours' => t.c_hours,
			    'priority' => @priority_name,
			    'started_on' => t.started_on.strftime("%d-%m-%Y"),
			    'ended_on' => t.ended_on.strftime("%d-%m-%Y"),
			    'assignee_name' => @assignee_name,
			    'assigner_name' => @assigner_name,
			    'project_board_id' => t.project_board_id,
			    'project_board_status' => @project_board_status,
			    'project_id' => t.project_id,
			    'project_name' => @project_name,
			    'sprint_id' => t.sprint_id,
			    'sprint_name' => @sprint_name,
			    'release_id' => t.release_id,
			    'release_name' => @release_name
			}
			end
			@respone = {
		        'list' => resp,
		        'count' => @tasks.count
		      }
      	render json: @respone
	end


	def show
	t = @task	
	      resp=[]
	      	@project_master = ProjectMaster.find_by_id(t.project_id)
            if @project_master!=nil and @project_master!=""
              @project_name =@project_master.project_name
            else
              @project_name =""
            end

            @release = Release.find_by_id(t.release_id)
            if @release!=nil and @release!=""
              @release_name =@release.name
            else
              @release_name =""
            end

            @sprint = Sprint.find_by_id(t.sprint_id)
            if @sprint!=nil and @sprint!=""
              @sprint_name =@sprint.name
            else
              @sprint_name =""
            end

            @board = ProjectBoard.find_by_id(t.project_board_id)
            if @board!=nil and @board!=""
              @project_board_status =@board.status
            else
              @project_board_status =""
            end

            @priority = TaskPriority.find_by_id(t.task_priority_id)
            if @priority!=nil and @priority!=""
              @priority_name =@priority.name
            else
              @priority_name =""
            end

            @assignee = User.find_by_id(t.assignee_id)
            if @assignee!=nil and @assignee!=""
              @assignee_name =@assignee.name
            else
              @assignee_name =""
            end

            @assigner = User.find_by_id(t.assigner_id)
            if @assigner!=nil and @assigner!=""
              @assigner_name =@assigner.name
            else
              @assigner_name =""
            end
		    resp << {
			    'id' => t.id,
			    'name' => t.name,			    
			    'description' => t.description,
			    'p_hours' => t.p_hours,
			    'c_hours' => t.c_hours,
			    'priority' => @priority_name,
			    'started_on' => t.started_on.strftime("%d/%m/%Y"),
			    'ended_on' => t.ended_on.strftime("%d/%m/%Y"),
			    'assignee_name' => @assignee_name,
			    'assigner_name' => @assigner_name,
			    'project_board_id' => t.project_board_id,
			    'project_board_status' => @project_board_status,
			    'project_id' => t.project_id,
			    'project_name' => @project_name,
			    'sprint_id' => t.sprint_id,
			    'sprint_name' => @sprint_name,
			    'release_id' => t.release_id,
			    'release_name' => @release_name
			}
			@respone = {
		        'list' => resp,
		        'count' => 1
		      }
      	render json: @respone
    end

	def create
	  @task = Task.new(task_params)
    	if @task.save          
    	  render json: { valid: true, msg:"#{@task.name} created successfully."}
     	else
          render json: { valid: false, error: @task.errors }, status: 404
     	end
    end

 	def update   
 	  if @task.update(task_params)  	
        @task.save  
        render json: { valid: true, msg:"#{@task.name} updated successfully."}
      else
        render json: { valid: false, error: @task.errors }, status: 404
      end
    end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find_by_id(params[:id])
        if @task
        else
      	  render json: { valid: false}, status: 404
        end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      raw_parameters = { :name => "#{params[:name]}", :description => "#{params[:description]}", :p_hours => "#{params[:p_hours]}",  :c_hours => "#{params[:c_hours]}", :started_on => "#{params[:started_on]}", :ended_on => "#{params[:ended_on]}", :assignee_id => "#{params[:assignee_id]}", :assigner_id => "#{params[:assigner_id]}", :task_priority_id => "#{params[:task_priority_id]}", :project_board_id => "#{params[:project_board_id]}", :project_id => "#{params[:project_id]}", :sprint_id => "#{params[:sprint_id]}", :release_id => "#{params[:release_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:name, :description, :p_hours, :c_hours, :started_on, :ended_on, :assignee_id, :assigner_id, :task_priority_id, :project_board_id, :project_id, :sprint_id, :release_id )
    
    end

end
