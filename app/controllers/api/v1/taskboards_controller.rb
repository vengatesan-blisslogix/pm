class Api::V1::TaskboardsController < ApplicationController

before_action :authenticate_user!
before_action :set_taskboards, only: [:show, :edit, :update]
 

 def index

get_all_projects


  #new
   task_resp =  []
   @task_board_id = ""
   @all_task = Taskboard.where("task_master_id IS NOT NULL and project_master_id=#{params[:project_master_id]} ") 
   @all_task.each do |at|
    if @task_board_id !=""
    @task_board_id = @task_board_id+','+at.task_master_id.to_s
    else
    @task_board_id = at.task_master_id.to_s 
    end
   end
   if @task_board_id == ""
    @unassigned = "project_master_id = #{params[:project_master_id]}"
   else
    @unassigned = "id NOT IN(#{@task_board_id}) and project_master_id = #{params[:project_master_id]} "
   end
   @task_masters = ProjectTask.where("#{@unassigned}")
   @task_masters.each do |t| 
    puts "----111---#{t.id}-------111---"
       
    get_assigne(t.id, "new")
     get_hours(t.id)
      task_resp << {
        'id' => t.id,
        'task_name' => t.task_name,
        'assign_params' => @assigned,
        'worked_hours' => @hours_resp
      }
    end
    #new


   new_task = []
   @progress = Taskboard.where(:new =>  true)
   @progress.each do |tp|  
   puts tp.task_master_id    
     @project_task = ProjectTask.find_by_id(tp.task_master_id)
      if @project_task!=nil and @project_task!=""
        get_task_board(@project_task.project_master_id)
        @task_name =@project_task.task_name
        @task_id =@project_task.id
       else
        @project_users_resp = ""
        @task_name =""
      end     
    get_assigne(tp.id, "new")

      new_task << {
        'taskboard_id' => tp.id,
        'task_id' => @task_id,
        'task_name' => @task_name,
        'assign_params' => @assigned,
        'worked_hours' => @hours_resp,
        'project_users' => @project_users_resp
      }
    end

   #in_progress
   in_progress = []
   @progress = Taskboard.where(:in_progress =>  true)
   @progress.each do |tp|      
     @project_task = ProjectTask.find_by_id(tp.task_master_id)
      if @project_task!=nil and @project_task!=""
        @task_name =@project_task.task_name
        @task_id =@project_task.id
       else
        @task_name =""
      end     
      get_task_board(@project_task.project_master_id)
      get_assigne(tp.id, "in_progress")
      in_progress << {
        'taskboard_id' => tp.id,
        'task_id' => @task_id,
        'task_name' => @task_name,        
        'assign_params' => @assigned,
        'worked_hours' => @hours_resp,
        'project_users' => @project_users_resp
      }
    end
    #in_progress


 
   #development_completed
   development_completed = []
   @development = Taskboard.where(:development_completed =>  true)
   @development.each do |td|      
     @project_task = ProjectTask.find_by_id(td.task_master_id)
      if @project_task!=nil and @project_task!=""
        @task_name =@project_task.task_name
        @task_id =@project_task.id
      else
        @task_name =""
      end        
      get_assigne(td.id, "development_completed")

      development_completed << {
        'taskboard_id' => td.id,
        'task_id' => @task_id,
        'task_name' => @task_name,
        'assign_params' => @assigned,
        'worked_hours' => @hours_resp,
        'project_users' => @project_users_resp
      }
    end
    #development_completed

    #qa
     qa = []
     @qa = Taskboard.where(:qa =>  true)
     @qa.each do |tq|      
       @project_task = ProjectTask.find_by_id(tq.task_master_id)
        if @project_task!=nil and @project_task!=""
          @task_name =@project_task.task_name
          @task_id =@project_task.id
        else
          @task_name =""
        end        
        get_assigne(tq.id, "qa")

        qa << {
          'taskboard_id' => tq.id,
          'task_id' => @task_id,
          'task_name' => @task_name,
          'assign_params' => @assigned,
          'worked_hours' => @hours_resp,
          'project_users' => @project_users_resp
        }
      end
      #qa

     #accepted
     accepted = []
     @accepted = Taskboard.where(:completed =>  true)
     @accepted.each do |tc|      
       @project_task = ProjectTask.find_by_id(tc.task_master_id)
        if @project_task!=nil and @project_task!=""
          @task_name =@project_task.task_name
          @task_id =@project_task.id
        else
          @task_name =""
        end       

        get_assigne(tc.id, "completed")

        accepted << {
          'taskboard_id' => tc.id,
          'task_id' => @task_id,
          'task_name' => @task_name,
          'assign_params' => @assigned,
          'worked_hours' => @hours_resp,
          'project_users' => @project_users_resp
        }
      end
      #accepted


   #hold
   hold = []
   @hold = Taskboard.where(:hold =>  true)
   @hold.each do |th|      
     @project_task = ProjectTask.find_by_id(th.task_master_id)
      if @project_task!=nil and @project_task!=""
        @task_name =@project_task.task_name
        @task_id =@project_task.id
      else
        @task_name =""
      end     
  
   get_assigne(th.id, "hold")

      hold << {
        'taskboard_id' => th.id,
        'task_id' => @task_id,
        'task_name' => @task_name,
        'assign_params' => @assigned,
        'worked_hours' => @hours_resp,
        'project_users' => @project_users_resp
      }
    end
    #hold


   @taskboards = Taskboard.page(params[:page])
    resp=[]
     @taskboards.each do |p| 
    
      if p.status.to_i==1
        @status=true
      else
        @status=false
      end
      
      resp << {
        'id' => p.id,
        'task_master_id' => p.task_master_id, 
        'in progress' => p.in_progress, 
        'development completed' => p.development_completed, 
        'QA' => p.qa, 
        'accepted' => p.completed, 
        'hold' => p.hold,
        'task_name' => @task_name        
      }
      end
   #@search=""
    pagination(Taskboard,@search)
    
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'project' => @project_resp,
      'new_task' => new_task,
      'new' => task_resp,
      'in_progress' => in_progress,
      'development_completed' => development_completed,
      'qa' => qa,
      'accepted' => accepted,
      'hold' => hold
    }

    render json: response
 end


	def show
	  render json: @taskboard
	end

	def create	  
	  @taskboard = Taskboard.new(taskboards_params)
	    if @taskboard.save
	      render json: { valid: true, msg: "taskboard created successfully"}
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
	       :in_progress => "#{params[:in_progress]}",
	       :development_completed => "#{params[:development_completed]}",
	       :qa => "#{params[:qa]}",
	       :completed => "#{params[:completed]}",
	       :hold => "#{params[:hold]}",
	       :task_master_id => "#{params[:task_master_id]}",
         :project_master_id => "#{params[:project_master_id]}",
         :sprint_planning_id => "#{params[:sprint_planning_id]}",
	       :description => "#{params[:description]}",
	       :est_time => "#{params[:est_time]}"      
	      }
	      
	      parameters = ActionController::Parameters.new(raw_parameters)
	      parameters.permit(:task_master_id, :project_master_id, :sprint_planning_id,:in_progress, :development_completed, :qa, :completed, :hold, :description, :est_time)
	    
	end
end
