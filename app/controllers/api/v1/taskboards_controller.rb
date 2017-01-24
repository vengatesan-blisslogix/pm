class Api::V1::TaskboardsController < ApplicationController

before_action :authenticate_user!
before_action :set_taskboards, only: [:show, :edit, :update]
 

  def index
    
 get_all_projects

      if params[:project_master_id] and params[:sprint_planning_id] 
        @search = "project_master_id = #{params[:project_master_id]} and sprint_planning_id = #{params[:sprint_planning_id]}"
      else
         if  @admin.to_i == 1      
          @search = "" 
        elsif @default_pro.to_i != 0
          @search = "project_master_id = #{@default_pro}"
        else
          if @search_all_pro_id==""
            @search="project_master_id IN(0)"
          else
            @search="project_master_id IN(#{@search_all_pro_id})"
          end   
        end     
      end

       task_resp = []
       if @search_val!="" or @admin.to_i == 1
   @task = Taskboard.where("#{@search}").order(:created_at => 'desc')
   @task.each do |tp|  
      
     @project_task = ProjectTask.find_by_id(tp.task_master_id)
      if @project_task!=nil and @project_task!=""
        get_task_board(@project_task.project_master_id)
        @task_name =@project_task.task_name
        @task_id =@project_task.id
       else
        @project_users_resp = ""
        @task_name =""
      end


    @project_master = ProjectMaster.find_by_id(tp.project_master_id)
      if @project_master!=nil and @project_master!=""
        @project_name =@project_master.project_name
      else
        @project_name =""
      end      

      @task_status_master = TaskStatusMaster.find_by_id(tp.task_status_master_id)
      if @task_status_master!=nil and @task_status_master!=""
        @status_name =@task_status_master.status
      else
        @status_name =""
      end      

        @sprint_planning = SprintPlanning.find_by_id(tp.sprint_planning_id)
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


    @assign = Taskboard.find_by_task_master_id(tp.task_master_id)
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
     

    
      task_resp << {
        'project_board_id' => tp.id,
        'task_id' => @task_id,
        'task_name' => @task_name,
        'assigned_user_id' => @assignee_id,
        'assignee_name' => @assignee,
        'assigner_name' => @assigneer,
        'project_board_status_id' => tp.task_status_master_id,
        'project_board_status' => @status_name,
        'project_master_id' => tp.project_master_id,
        'project_name' => @project_name,
        'sprint_planning_id' => tp.sprint_planning_id,
        'sprint_name' => @sprint_name,
        'release_id' => @release_id,
        'release_name' => @release_name
        }
    end
  end

   @respone = {
            'list' => task_resp,
            'count' => task_resp.count
          }
        render json: @respone

 end


	def show
      tp = @taskboard

    task_resp = []
      
     @project_task = ProjectTask.find_by_id(tp.task_master_id)
      if @project_task!=nil and @project_task!=""
        get_task_board(@project_task.project_master_id)
        @task_name =@project_task.task_name
        @task_id =@project_task.id
       else
        @project_users_resp = ""
        @task_name =""
      end


    @project_master = ProjectMaster.find_by_id(tp.project_master_id)
      if @project_master!=nil and @project_master!=""
        @project_name =@project_master.project_name
      else
        @project_name =""
      end      

      @task_status_master = TaskStatusMaster.find_by_id(tp.task_status_master_id)
      if @task_status_master!=nil and @task_status_master!=""
        @status_name =@task_status_master.status
      else
        @status_name =""
      end      

        @sprint_planning = SprintPlanning.find_by_id(tp.sprint_planning_id)
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


    @assign = Taskboard.find_by_task_master_id(tp.task_master_id)
       if @assign!=nil and @assign!=""
         @taskboard_id =@assign.id
         @find_assigne =  Assign.where("taskboard_id=#{@taskboard_id}")
              @assignee = []

         @find_assigne.each do |a|

              @assigneer = []

          @assigner = User.find_by_id(a.assigneer_id)
            if @assigner!=nil and @assigner!=""
              @assigneer   << { 'id' => @assigner.id,
                              'name' => "#{@assigner.name} #{@assigner.last_name}"}
            else
              @assigneer   =""
            end

          @users = User.find_by_id(a.assigned_user_id)
           if @users!=nil and @users!=""
             @assignee_id = @users.id
             @assignee   << { 'id' => @assignee_id,
                            'name' => "#{@users.name} #{@users.last_name}"}
           else
             @assignee_id = ""
             @assignee   =""
           end
       end
    
      task_resp << {
        'project_board_id' => tp.id,
        'task_id' => @task_id,
        'task_name' => @task_name,
        'assigned_user_id' => @assignee_id,
        'assignee_name' => @assignee,
        'assigner_name' => @assigneer,
        'project_board_status_id' => tp.task_status_master_id,
        'project_board_status' => @status_name,
        'project_master_id' => tp.project_master_id,
        'project_name' => @project_name,
        'sprint_planning_id' => tp.sprint_planning_id,
        'sprint_name' => @sprint_name,
        'release_id' => @release_id,
        'release_name' => @release_name
        }
    end
  

   @respone = {
            'list' => task_resp,
            'count' => task_resp.count
          }
        render json: @respone
 end


 def create    
    @taskboard = Taskboard.new(taskboards_params)      
      if @taskboard.save
         @taskboard.task_status_master_id = 1       
         @taskboard.status = "active"
        @taskboard.save

    un_assigned={
          'valid' => true, 
          'msg' => "created successfully"
          }

        render json: un_assigned
      else
        render json: { valid: false, error: @taskboard.errors }, status: 404
      end
  end


	def update
	  if @taskboard.update(taskboards_params)
        if params[:log] != nil and params[:log].to_i == 1         
            @timelog = Logtime.new
              if params[:task_time] and params[:task_time]!=nil
                @timelog.task_time = params[:task_time]
              else
                @timelog.start_time = params[:start_time]
                @timelog.end_time = params[:end_time]
              end
              @timelog.taskboard_id = @taskboard.id
              @timelog.project_master_id = @taskboard.project_master_id
              @timelog.sprint_planning_id = @taskboard.sprint_planning_id
              @timelog.task_master_id = @taskboard.task_master_id
              @timelog.task_date = params[:date]
              @timelog.user_id = params[:user_id]
              @timelog.status = "pending"
           @timelog.save
         end
          
          log_values = []

          log_values << {
            'taskboard_id' => @timelog.taskboard_id,
            'task_time' => @timelog.task_time
            }
          

            if params[:assign] != nil and params[:assign].to_i == 1         
              convert_param_to_array(params[:assigned_user_id])
              @assigned_user_id = @output_array
                p=0
                  @assigned_user_id.each do |user|
                    
                    @find_user = Assign.where("taskboard_id = #{@taskboard.id} and assigned_user_id = #{user}")
                      if @find_user != nil and @find_user.size != 0

                      else
                        @assign = Assign.new                      
                        @assign.taskboard_id = @taskboard.id
                        @assign.assigned_user_id = user
                        @assign.assigneer_id = params[:user_id]
                        @assign.track_id = params[:user_id]
                        @assign.save
                      end
                  end
              end   
     
    	    render json: { valid: true, msg: "taskboard updated with log_values"}      
	  else
	    render json: { valid: false, error: @taskboard.errors }, status: 404
	  end
	end

private
	def set_taskboards
	@taskboard = Taskboard.find_by_id(params[:id])
      if @taskboard
      else
      	render json: { valid: false}, status: 404
      end
	end


	def taskboards_params           
	    
	      raw_parameters = { 	      
         :task_status_master_id => "#{params[:task_status_master_id]}",
	       :task_master_id => "#{params[:task_master_id]}",
         :project_master_id => "#{params[:project_master_id]}",
         :sprint_planning_id => "#{params[:sprint_planning_id]}",
	       :description => "#{params[:description]}",
	       :est_time => "#{params[:est_time]}"      
	      }
	      
	      parameters = ActionController::Parameters.new(raw_parameters)
	      parameters.permit(:task_master_id, :project_master_id, :sprint_planning_id, :task_status_master_id, :description, :est_time)
	    
	end
end
