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

      @task_status_master = TaskStatusMaster.find_by_id(p.project_board_id)
      if @task_status_master!=nil and @task_status_master!=""
        @status_name =@task_status_master.status
      else
        @status_name =""
      end      

      @project_task_reason = ProjectTaskReason.find_by_project_task_id(p.id)
      if @project_task_reason!=nil and @project_task_reason!=""
        @date_reason =@project_task_reason.date_reason
        @hour_reason =@project_task_reason.hour_reason
        @sch_start =@project_task_reason.sch_start
        @sch_end =@project_task_reason.sch_end
        @delayed_type =@project_task_reason.delayed_type

      else
        @date_reason =""
        @hour_reason =""
        @sch_start =""
        @sch_end =""
        @delayed_type =""
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
              @assigneer_id = @assigner.id
              @assigneer   ="#{@assigner.name} #{@assigner.last_name}"
            else
              @assigneer_id = ""
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

     @pri_name = TaskPriority.find_by_id(p.priority_id)
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
          'task_name' => p.task_name,         
          'task_description' => p.task_description,
          'planned' => p.planned,
          'actual' => p.actual,
          'priority_id' => p.priority_id,
          'priority_name' => @priority_name,
          'planned_duration' => @pd,
          'actual_duration' => @ad,
          'assigned_user_id' => @assignee_id,
          'assignee_name' => @assignee,
          'assigneer_id' => @assigneer_id,
          'assigner_name' => @assigneer,
          'project_board_id' => p.project_board_id,
          'project_board_status' => @status_name,
          'project_master_id' => p.project_master_id,
          'project_name' => @project_name,
          'sprint_planning_id' => @sprint_id,
          'sprint_name' => @sprint_name,
          'release_planning_id' => @release_id,
          'release_name' => @release_name,
          'date_reason' => @date_reason,
          'hour_reason' => @hour_reason,
          'sch_start' => @sch_start,
          'sch_end' => @sch_end,
          'delayed_type' => @delayed_type
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

      @task_status_master = TaskStatusMaster.find_by_id(p.project_board_id)
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
              @assigneer_id = @assigner.id
              @assigneer   ="#{@assigner.name} #{@assigner.last_name}"
            else
              @assigneer_id = ""
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

     @pri_name = TaskPriority.find_by_id(p.priority_id)
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



      @project_task_reason = ProjectTaskReason.where("project_task_id = #{p.id}")
        @ptr = []
        @project_task_reason.each do |ptr|

      if @project_task_reason!=nil and @project_task_reason!=""
        @ptr << {
          'date_reason' => ptr.date_reason,
          'hour_reason' => ptr.hour_reason,
          'sch_start' => ptr.sch_start,
          'sch_end' => ptr.sch_end,
          'delayed_type' => ptr.delayed_type          
        }
      else
        @date_reason =""
        @hour_reason =""
        @sch_start =""
        @sch_end =""
        @delayed_type =""
      end      
    end
            
    resp << {
          'id' => p.id,
          'task_name' => p.task_name,         
          'task_description' => p.task_description,
          'planned' => p.planned,
          'actual' => p.actual,
          'priority_id' => p.priority_id,
          'priority_name' => @priority_name,
          'planned_duration' => @pd,
          'actual_duration' => @ad,
          'assigned_user_id' => @assignee_id,
          'assignee_name' => @assignee,
          'assigneer_id' => @assigneer_id,
          'assigner_name' => @assigneer,
          'project_board_id' => p.project_board_id,
          'project_board_status' => @status_name,
          'project_master_id' => p.project_master_id,
          'project_name' => @project_name,
          'sprint_planning_id' => @sprint_id,
          'sprint_name' => @sprint_name,
          'release_planning_id' => @release_id,
          'release_name' => @release_name,
          'reason' => @ptr
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
          @project.active = "active"
          #@project.planned = params[:planned_duration]

        @project.save

        #if params[:avatar]!=nil and params[:avatar]!=""
          #convert_param_to_array(params[:avatar].to_s)
            #@avatar = @output_array
            #p=0
            #@avatar.each do |at|
              #puts "-----------#{at}"
              #@attachment = ProjectTaskAttachment.new
                #@attachment.project_task_id = @project.id
                #@attachment.updated_by = params[:user_id]
                #@attachment.avatar = at
              #@attachment.save
              #set_avatar(at, @attachment)
            #end
        #end

              @attachment = ProjectTaskAttachment.new
                @attachment.project_task_id = @project.id
                @attachment.updated_by = params[:user_id]
                @attachment.avatar = params[:avatar]
              @attachment.save


          if params[:assigned_user_id]!=nil and params[:assigned_user_id]!=""
            convert_param_to_array(params[:assigned_user_id].to_s)
            @assigned_user_id = @output_array
            p=0
            @assigned_user_id.each do |user|
              @taskboard = Taskboard.new
                @taskboard.task_status_master_id = 1
                @taskboard.task_master_id = @project.id
                @taskboard.project_master_id = @project.project_master_id
                @taskboard.sprint_planning_id = params[:sprint_planning_id]
                @taskboard.status = "active"
              @taskboard.save
            @assign = Assign.new
              @assign.taskboard_id = @taskboard.id
              @assign.assigned_user_id = user
              @assign.assigneer_id = params[:user_id]
            @assign.save!
            p=p+1
          end
    end


    	render json: { valid: true, msg:"#{@project.task_name} created successfully."}
     else
        render json: { valid: false, error: @project.errors }, status: 404
     end    
  end

 def update   

    if @project.update(project_params)  	
      @project.save
          @project.active = "active"         
        @project.save

          @attachment = ProjectTaskAttachment.new
                @attachment.project_task_id = @project.id
                @attachment.updated_by = params[:user_id]
                @attachment.avatar = params[:avatar]
          @attachment.save

            if params[:date_reason]|| params[:hour_reason].present?
              @task_reason = ProjectTaskReason.new
                    @task_reason.project_task_id = @project.id
                    @task_reason.date_reason = params[:date_reason]
                    @task_reason.hour_reason = params[:hour_reason]
                    @task_reason.created_by = params[:user_id]
                    @task_reason.sch_start = params[:sch_start]
                    @task_reason.sch_end = params[:sch_end]
                    @task_reason.delayed_type = params[:delayed_type]
                    @task_reason.project_master_id = @project.project_master_id

              @task_reason.save            
            end

        #if params[:avatar]!=nil and params[:avatar]!=""
          #convert_param_to_array(params[:avatar].to_s)
            #@avatar = @output_array
            #p=0
            #@avatar.each do |at|
              #puts "-----------#{at}"
              #@attachment = ProjectTaskAttachment.new
                #@attachment.project_task_id = @project.id
                #@attachment.updated_by = params[:user_id]
                #@attachment.avatar = at
              #@attachment.save
              #set_avatar(at, @attachment)
            #end
        #end

        if params[:assigned_user_id]!=nil and params[:assigned_user_id]!=""
            convert_param_to_array(params[:assigned_user_id].to_s)
            @assigned_user_id = @output_array
            p=0
            @assigned_user_id.each do |user|
              @find_taskboard = Taskboard.find_by_task_master_id(@project.id)
              if @find_taskboard != nil and @find_taskboard != ""
                @taskboard = @find_taskboard
              else
                @taskboard = Taskboard.new
              end
                @taskboard.task_status_master_id = 1
                @taskboard.task_master_id = @project.id
                @taskboard.project_master_id = @project.project_master_id
                @taskboard.sprint_planning_id = params[:sprint_planning_id]
                @taskboard.status = "active"
              @taskboard.save
                @find_assign = Assign.where("assigned_user_id = #{user} and taskboard_id = #{@taskboard.id}")
                  if @find_assign != nil and @find_assign != "" and @find_assign.size != 0
                    @assign = @find_assign[0]
                  else
                    @assign = Assign.new
                  end
                      @assign.taskboard_id = @taskboard.id
                      @assign.assigned_user_id = user
                      @assign.assigneer_id = params[:user_id]
                    @assign.save!
                    p=p+1
                  end
          end 
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

    def set_avatar(at, attachment)
      attachment.avatar = at
      attachment.save
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :task_name => "#{params[:task_name]}", :task_description => "#{params[:task_description]}", :active => "#{params[:active]}",  :priority_id => "#{params[:priority_id]}", :project_master_id => "#{params[:project_master_id]}", :project_board_id => "#{params[:project_board_id]}", :planned_duration => "#{params[:planned_duration]}", :actual_duration => "#{params[:actual_duration]}", :planned => "#{params[:planned]}", :actual => "#{params[:actual]}", :sc_start => "#{params[:sc_start]}", :sc_end => "#{params[:sc_end]}", :delay_type => "#{params[:delay_type]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:task_name, :task_description, :active, :priority_id, :project_master_id, :project_board_id, :planned_duration, :actual_duration, :planned, :actual, :sc_start, :sc_end, :delay_type) 
    
    end


end
