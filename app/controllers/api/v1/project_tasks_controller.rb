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


      @task = Taskboard.find_by_task_master_id(p.id)
      if  @task!=nil and @task!=""

        @sprint_planning = SprintPlanning.find_by_id(@task.sprint_planning_id)
         if @sprint_planning!=nil and @sprint_planning!=""
           @sprint_name =@sprint_planning.sprint_name
            @sprint_id =@sprint_planning.id
              @release_planning = ReleasePlanning.find_by_id(@sprint_planning.release_planning_id)
               if @release_planning!=nil and @release_planning!=""
                 @release_name =@release_planning.release_name
                  @release_id =@release_planning.id
               else
                 @release_name =""
               end    
         else
           @sprint_name =""
           @release_name =""
         end    
      else
        @sprint_name =""
        @release_name =""
      end

      @assign = Taskboard.find_by_task_master_id(p.id)
       if @assign!=nil and @assign!=""
         @taskboard_id =@assign.id
         @find_assigne =  Assign.where("taskboard_id=#{@taskboard_id}")

         @find_assigne.each do |a|
         
          @assigner = User.find_by_id(a.assigneer_id)
            if @assigner!=nil and @assigner!=""
              @assigneer   ="#{@assigner.name} #{@assigner.last_name}"
            else
              @assigneer   =""
            end

          @users = User.find_by_id(a.assigned_user_id)
           if @users!=nil and @users!=""
             @assignee_id = @users.id
             @assignee   ="#{@users.name} #{@users.last_name}"
           else
             @assignee_id = ""
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

      if p.planned_duration!=nil and p.planned_duration!=""
        @pd = p.planned_duration.strftime("%d-%m-%Y")
      else
        @pd = ""
      end

      if p.actual_duration!=nil and p.actual_duration!=""
        @ad = p.actual_duration.strftime("%d-%m-%Y")
      else
        @ad = ""
      end

            
    resp << {
          'id' => p.id,
          'name' => p.task_name,         
          'description' => p.task_description,
          'p_hours' => p.planned,
          'c_hours' => p.actual,
          'priority_id' => p.priority,
          'priority_name' => @priority_name,
          'started_on' => @pd,
          'ended_on' => @ad,
          'assignee_id' => @assignee_id,
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
  puts  "----params[:id]---"

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


      @task = Taskboard.find_by_task_master_id(p.id)
      if  @task!=nil and @task!=""

        @sprint_planning = SprintPlanning.find_by_id(@task.sprint_planning_id)
         if @sprint_planning!=nil and @sprint_planning!=""
           @sprint_name =@sprint_planning.sprint_name
            @sprint_id =@sprint_planning.id
              @release_planning = ReleasePlanning.find_by_id(@sprint_planning.release_planning_id)
               if @release_planning!=nil and @release_planning!=""
                 @release_name =@release_planning.release_name
                  @release_id =@release_planning.id
               else
                 @release_name =""
               end    
         else
           @sprint_name =""
           @release_name =""
         end    
      else
        @sprint_name =""
        @release_name =""
      end

      @assign = Taskboard.find_by_task_master_id(p.id)
       if @assign!=nil and @assign!=""
         @taskboard_id =@assign.id
         @find_assigne =  Assign.where("taskboard_id=#{@taskboard_id}")

         @find_assigne.each do |a|
         
          @assigner = User.find_by_id(a.assigneer_id)
            if @assigner!=nil and @assigner!=""
              @assigneer   ="#{@assigner.name} #{@assigner.last_name}"
            else
              @assigneer   =""
            end

          @users = User.find_by_id(a.assigned_user_id)
           if @users!=nil and @users!=""
             @assignee_id = @users.id
             @assignee   ="#{@users.name} #{@users.last_name}"
           else
             @assignee_id = ""
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

      if p.planned_duration!=nil and p.planned_duration!=""
        @pd = p.planned_duration.strftime("%d-%m-%Y")
      else
        @pd = ""
      end

      if p.actual_duration!=nil and p.actual_duration!=""
        @ad = p.actual_duration.strftime("%d-%m-%Y")
      else
        @ad = ""
      end

            
    resp << {
          'id' => p.id,
          'name' => p.task_name,         
          'description' => p.task_description,
          'p_hours' => p.planned,
          'c_hours' => p.actual,
          'priority_id' => p.priority,
          'priority_name' => @priority_name,
          'started_on' => @pd,
          'ended_on' => @ad,
          'assignee_id' => @assignee_id,
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
      
      @respone = {
            'list' => resp,
            'count' => 1
          }
        render json: @respone
  end


def create

    @project = ProjectTask.new(project_params)
    if @project.save
      @project.project_master_id = params[:project_id]
          @project.active = "active"
          @project.planned = params[:planned_duration]
        @project.save
    	render json: { valid: true, msg:"#{@project.task_name}#{@project.id} created successfully."}
     else
        render json: { valid: false, error: @project.errors }, status: 404
     end
    
end

 def update   

    if @project.update(project_params)  	
      @project.save

          @project.project_master_id = params[:project_id]
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

      raw_parameters = { :task_name => "#{params[:task_name]}", :task_description => "#{params[:task_description]}", :active => "#{params[:active]}",  :priority => "#{params[:priority]}", :project_master_id => "#{params[:project_id]}", :task_status_master_id => "#{params[:task_status_master_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:task_name, :task_description, :active, :priority, :project_master_id, :task_status_master_id )
    
    end


end
