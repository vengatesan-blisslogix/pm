class Api::V1::TaskboardsController < ApplicationController

before_action :authenticate_user!
before_action :set_taskboards, only: [:show, :edit, :update]
 

  def index
    get_all_projects

    if  @admin.to_i == 1
      @search_val = ""
    elsif params[:project_master_id] and params[:sprint_planning_id]
      @search_val = "project_master_id = #{params[:project_master_id]} and sprint_planning_id = #{params[:sprint_planning_id]}"
    elsif @default_pro.to_i != 0
      @search_val = "project_master_id = #{@default_pro}"          
    else
      @search_val = ""
    end

       task_resp = []
       if @search_val!="" or @admin.to_i == 1
   @task = Taskboard.where("#{@search_val}")
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
        'project_id' => tp.project_master_id,
        'project_name' => @project_name,
        'sprint_id' => tp.sprint_planning_id,
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
    
      task_resp << {
        'project_board_id' => tp.id,
        'task_id' => @task_id,
        'task_name' => @task_name,
        'assigned_user_id' => @assignee_id,
        'assignee_name' => @assignee,
        'assigner_name' => @assigneer,
        'project_board_status_id' => tp.task_status_master_id,
        'project_board_status' => @status_name,
        'project_id' => tp.project_master_id,
        'project_name' => @project_name,
        'sprint_id' => tp.sprint_planning_id,
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
	    render json: { valid: true, msg: "taskboard updated successfully"}
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
