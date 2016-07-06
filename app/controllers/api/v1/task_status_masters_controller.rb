class Api::V1::TaskStatusMastersController < ApplicationController

before_action :authenticate_user!
before_action :set_task_status_master, only: [:show, :edit, :update]

 def index
   @task_status_masters = TaskStatusMaster.page(params[:page])
    resp=[]
     @task_status_masters.each do |p| 
    
      
      resp << {
        'id' => p.id,
        'status' => p.status        
      }
      end
   #@search=""
    pagination(TaskStatusMaster,@search)
    
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'task_status_master' => resp
    }

    render json: response
 end


	def show
	  render json: @task_status_master
	end

	def create	  
	  @task_status_master = TaskStatusMaster.new(task_status_master_params)
	    if @task_status_master.save
	      render json: { valid: true, msg:"#{@task_status_master.status} created successfully."}  
	    else
	      render json: { valid: false, error: @task_status_master.errors }, status: 404
	    end
	end


	def update
	  if @task_status_master.update(task_status_master_params)  	      
	    render json: @task_status_master
	  else
	    render json: { valid: false, error: @task_status_master.errors }, status: 404
	  end
	end

private
	def set_task_status_master
	@task_status_master = TaskStatusMaster.find_by_id(params[:id])
      if @task_status_master
      else
      	render json: { valid: false}, status: 404
      end
	end


	def task_status_master_params           
	    
	      raw_parameters = { 
	       :status => "#{params[:status]}"
	      }
	      
	      parameters = ActionController::Parameters.new(raw_parameters)
	      parameters.permit(:status)
	    
	end

end
