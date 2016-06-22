class Api::V1::SprintPlanningsController < ApplicationController

before_action :authenticate_user!
before_action :set_sprint, only: [:show, :edit, :update]

	def index

  get_all_projects

    if params[:project_master_id] && params[:release_planning_id]
      @search = "project_master_id = #{params[:project_master_id]} and release_planning_id = #{params[:release_planning_id]}"

        @project_master = ProjectMaster.find_by_id(params[:project_master_id])
            if @project_master!=nil and @project_master!=""
              @project_name =@project_master.project_name
            else
              @project_name =""
            end

            @release_planning = ReleasePlanning.find_by_id(params[:release_planning_id])

            if @release_planning!=nil and @release_planning!=""
              @release_name =@release_planning.release_name
            else
              @release_name =""
            end

    else
      @search = ""
    end


puts "#{@search}"

	  @sprint_plannings = SprintPlanning.where(@search).page(params[:page])
	  resp=[]
     @sprint_plannings.each do |p| 


      if p.active.to_i==1
        @status= "open"
      elsif p.active.to_i==2
        @status= "ongoing"
      else
        @status= "closed"
      end
    
 
  if @search==""
    puts "#{@search}"
      @project_master = ProjectMaster.find_by_id(p.project_master_id)
      if @project_master!=nil and @project_master!=""
        @project_name =@project_master.project_name
      else
        @project_name =""
      end
      if p.project_master_id!=nil and p.release_planning_id !=nil
            @release_planning = ReleasePlanning.where("project_master_id = #{p.project_master_id} and id = #{p.release_planning_id}").first

            if @release_planning!=nil and @release_planning!=""
              @release_name =@release_planning.release_name                
            else
              @release_name =""
            end
          end
          else
            release_name =""
            puts "---------@release_name-----------"
      end
      resp << {
        'id' => p.id,
        'project_name' => @project_name,
        'release_name' => @release_name,
        'sprint_name' => p.sprint_name,
        'active' => @status,
        'start_date' => p.start_date,        
        'end_date' => p.end_date,
        'sprint_desc' => p.sprint_desc
        }
      end
    pagination(SprintPlanning,@search)
    
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'sprints' => resp,
      'project' => @project_resp

    }

    render json: response
 end

	def show	
	  render json: @sprint_planning
	end

	def create
	  @sprint_planning = SprintPlanning.new(sprint_params)
	    if @sprint_planning.save
        @sprint_planning.active = "1"
        @sprint_planning.save
       # SprintStatus.create(status: "active", active: 1, user_id: 1)
		    render json: { valid: true, msg:"#{@sprint_planning.sprint_name} created successfully."}  
      #index
		else
		  render json: { valid: false, error: @sprint_planning.errors }, status: 404
		end    
	end

	def update 
	  if @sprint_planning.update(sprint_params)  	      
	    render json: @sprint_planning
	  else
        render json: { valid: false, error: @sprint_planning.errors }, status: 404
	  end
	end


private

    def set_sprint
      @sprint_planning = SprintPlanning.find_by_id(params[:id])
      if @sprint_planning
      else
        render json: { valid: false}, status: 404
      end
    end

    def sprint_params
      raw_parameters = { :active => "#{params[:active]}", :start_date => "#{params[:start_date]}", :end_date => "#{params[:end_date]}", :sprint_name => "#{params[:sprint_name]}", :sprint_desc => "#{params[:sprint_desc]}", :sprint_status_id => "#{params[:sprint_status_id]}", :release_planning_id => "#{params[:release_planning_id]}", :project_master_id => "#{params[:project_master_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit( :active, :start_date, :end_date, :sprint_name, :sprint_desc, :sprint_status_id, :project_master_id, :release_planning_id)
    end

end
