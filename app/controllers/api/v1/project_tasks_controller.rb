class Api::V1::ProjectTasksController < ApplicationController

before_action :authenticate_user!
before_action :set_project, only: [:show, :edit, :update]

 def index

  get_all_projects
  get_all_project_task_status

      if params[:project_master_id] 
        @search = "project_master_id = #{params[:project_master_id]}"
      else
        if @search_all_pro_id==""
          if current_user.role_master_id==1
            @search = ""
          else

        @search = "project_master_id IN(0)"
        end
      else
        @search = "project_master_id IN(#{@search_all_pro_id})"
      end
      end

    @project_tasks = ProjectTask.where(@search).page(params[:page]).order(:created_at => 'desc')
    resp=[]
     @project_tasks.each do |p| 
  


      @project_master = ProjectMaster.find_by_id(p.project_master_id)
      if @project_master!=nil and @project_master!=""
        @project_name =@project_master.project_name
      else
        @project_name =""
      end      

      @task_status_master = TaskStatusMaster.find_by_id(p.task_status_master_id)
      if @task_status_master!=nil and @task_status_master!=""
        @status_name =@task_status_master.status
      else
        @status_name =""
      end      

      @release_planning = ReleasePlanning.find_by_project_master_id(p.project_master_id)
       if @release_planning!=nil and @release_planning!=""
         @release_name =@release_planning.release_name
          @release_id =@release_planning.id
       else
         @release_name =""
       end    

      @sprint_planning = SprintPlanning.find_by_project_master_id(p.project_master_id)
       if @sprint_planning!=nil and @sprint_planning!=""
         @sprint_name =@sprint_planning.sprint_name
          @sprint_id =@sprint_planning.id
       else
         @sprint_name =""
       end    

      @assign = Taskboard.find_by_project_master_id(p.project_master_id)
       if @assign!=nil and @assign!=""
         @taskboard_id =@assign.id
         @find_assigne =  Assign.where("taskboard_id=#{@taskboard_id}")

         @find_assigne.each do |a|
         
          @users = User.find_by_id(a.assigned_user_id)
           if @users!=nil and @users!=""
             @assignee   ="#{@users.name} #{@users.last_name}"
           else
             @assignee   =""
           end
       end
     end

     @pri_name = TaskPriority.find_by_id(p.priority)
      if @pri_name!=nil and @pri_name!=""
        @priority_name =@pri_name.name
      else
        @priority_name =""
      end     


     @assigner = Taskboard.find_by_id(p.project_master_id)
       if @assigner!=nil and @assigner!=""
         @taskboard_id =@assigner.id
         @find_assigneer =  Assign.where("taskboard_id=#{@taskboard_id}")

         @find_assigneer.each do |as|
         
          @users = User.find_by_id(as.assigneer_id)
           if @users!=nil and @users!=""
             @assigneer   ="#{@users.name} #{@users.last_name}"
           else
             @assigneer   =""
           end
       end
     end


            
    resp << {
          'id' => p.id,
          'name' => p.task_name,         
          'description' => p.task_description,
          'p_hours' => p.planned,
          'c_hours' => p.actual,
          'priority_id' => p.priority,
          'priority_name' => @priority_name,
          'started_on' => p.planned_duration.strftime("%d-%m-%Y"),
          'ended_on' => p.actual_duration.strftime("%d-%m-%Y"),
          'assignee_name' => @assignee,
          'assigner_name' => @assigneer,
          'project_board_id' => p.task_status_master_id,
          'project_board_status' => @status_name,
          'project_id' => p.project_master_id,
          'project_name' => @project_name,
          'sprint_id' => @sprint_id,
          'sprint_name' => @sprint_name,
          'release_id' => @release_id,
          'release_name' => @release_name
      }
      end
      @respone = {
            'list' => resp,
            'count' => @project_tasks.count
          }
        render json: @respone
  end


def show	
  p = @project

  resp=[]

      @project_master = ProjectMaster.find_by_id(p.project_master_id)
      if @project_master!=nil and @project_master!=""
        @project_name =@project_master.project_name
      else
        @project_name =""
      end      

      @task_status_master = TaskStatusMaster.find_by_id(p.task_status_master_id)
      if @task_status_master!=nil and @task_status_master!=""
        @status_name =@task_status_master.status
      else
        @status_name =""
      end      

      @release_planning = ReleasePlanning.find_by_project_master_id(p.project_master_id)
       if @release_planning!=nil and @release_planning!=""
         @release_name =@release_planning.release_name
          @release_id =@release_planning.id
       else
         @release_name =""
       end    

      @sprint_planning = SprintPlanning.find_by_project_master_id(p.project_master_id)
       if @sprint_planning!=nil and @sprint_planning!=""
         @sprint_name =@sprint_planning.sprint_name
          @sprint_id =@sprint_planning.id
       else
         @sprint_name =""
       end    

      @pri_name = TaskPriority.find_by_id(p.priority)
      if @pri_name!=nil and @pri_name!=""
        @priority_name =@pri_name.name
      else
        @priority_name =""
      end     

      @assign = Taskboard.find_by_project_master_id(p.project_master_id)
       if @assign!=nil and @assign!=""
         @taskboard_id =@assign.id
         @find_assigne =  Assign.where("taskboard_id=#{@taskboard_id}")

         @find_assigne.each do |a|
         
          @users = User.find_by_id(a.assigned_user_id)
           if @users!=nil and @users!=""
             @assignee   ="#{@users.name} #{@users.last_name}"
           else
             @assignee   =""
           end
       end
     end


      @assigner = Taskboard.find_by_id(p.project_master_id)
       if @assigner!=nil and @assigner!=""
         @taskboard_id =@assigner.id
         @find_assigneer =  Assign.where("taskboard_id=#{@taskboard_id}")

         @find_assigneer.each do |as|
         
          @users = User.find_by_id(as.assigneer_id)
           if @users!=nil and @users!=""
             @assigneer   ="#{@users.name} #{@users.last_name}"
           else
             @assigneer   =""
           end
       end
     
     
            
    resp << {
          'id' => p.id,
          'name' => p.task_name,         
          'description' => p.task_description,
          'p_hours' => p.planned,
          'c_hours' => p.actual,
          'priority_id' => p.priority,
          'priority_name' => @priority_name,         
          'started_on' => p.planned_duration.strftime("%d-%m-%Y"),
          'ended_on' => p.actual_duration.strftime("%d-%m-%Y"),
          'assignee_name' => @assignee,
          'assigner_name' => @assigneer,
          'project_board_id' => p.task_status_master_id,
          'project_board_status' => @status_name,
          'project_id' => p.project_master_id,
          'project_name' => @project_name,
          'sprint_id' => @sprint_id,
          'sprint_name' => @sprint_name,
          'release_id' => @release_id,
          'release_name' => @release_name
      }
      end
      @respone = {
            'list' => resp,
            'count' => 1
          }
        render json: @respone
  end


def create

    @project = ProjectTask.new(project_params)
    if @project.save
          @project.active = "active"
          @project.planned = params[:planned_duration]
        @project.save
    	render json: { valid: true, msg:"#{@project.task_name} created successfully."}
     else
        render json: { valid: false, error: @project.errors }, status: 404
     end
    
end

 def update   

    if @project.update(project_params)  	
      @project.save
          @project.planned = params[:planned_duration]
          @project.task_status_master_id = 1
        @project.save  
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

      raw_parameters = { :task_name => "#{params[:task_name]}", :task_description => "#{params[:task_description]}", :active => "#{params[:active]}",  :priority => "#{params[:priority]}", :project_master_id => "#{params[:project_master_id]}", :task_status_master_id => "#{params[:task_status_master_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:task_name, :task_description, :active, :priority, :project_master_id, :task_status_master_id )
    
    end


end
