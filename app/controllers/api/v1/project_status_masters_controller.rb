class Api::V1::ProjectStatusMastersController < ApplicationController

before_action :authenticate_user!
before_action :set_project_status_master, only: [:show, :edit, :update]

 def index
     #search
        if params[:search]!=nil and params[:search]!=""
          @search ="id = #{params[:search]}"
        else
          @search =""
        end
     #search

   @project_status_masters = ProjectStatusMaster.where("#{@search}").page(params[:page])
    resp=[]
     @project_status_masters.each do |ps| 
    
      if ps.active.to_i==1
        @status = "active"
      else
        @status = "inactive"
      end

      resp << {
        'id' => ps.id,        
        'status' => ps.status,
        'active' => @status,
        'description' => ps.description      
      }
      end

    pagination(ProjectStatusMaster,@search)
    
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'project_status_master' => resp
    }

    render json: response
 end


	def show
		resp=[]

      if @project_status_master.active.to_i==1
        @status = "active"
      else
        @status = "inactive"
      end

      resp << {
        'id' => @project_status_master.id,
        'domain_name' => @project_status_master.domain_name,
        'active' => @status
      }
   render json: resp
	  #render json: @project_status_master
	end

	def create	  
	  @project_status_master = ProjectStatusMaster.new(project_status_master_params)
	    if @project_status_master.save
	    	 @project_status_master.active = 1
        @project_status_master.save
    
    	render json: { valid: true, msg:"#{@project_status_master.status} created successfully."}  
	    else
	      render json: { valid: false, error: @project_status_master.errors }, status: 404
	    end
	end


	def update
	  if @project_status_master.update(project_status_master_params) 
	  if params[:active] == "active"
      @project_status_master.active = 1
    else
      @project_status_master.active = 0
    end
    @project_status_master.save 	      
render json: { valid: true, msg:"#{@project_status_master.status} updated successfully."}
	  else
	    render json: { valid: false, error: @project_status_master.errors }, status: 404
	  end
	end

private
	def set_project_status_master
	@project_status_master = ProjectStatusMaster.find_by_id(params[:id])
      if @project_status_master
      else
      	render json: { valid: false}, status: 404
      end
	end


	def project_status_master_params           
	    
	      raw_parameters = { 
	       :status => "#{params[:status]}", :active => "#{params[:active]}", :description => "#{params[:description]}"
	      }
	      
	      parameters = ActionController::Parameters.new(raw_parameters)
	      parameters.permit(:status, :active, :description)
	    
	end

end
