class Api::V1::SprintPlanningsController < ApplicationController

before_action :authenticate_user!
before_action :set_sprint, only: [:show, :edit, :update]

	def index

  get_all_projects

   if params[:project_master_id] 
        @search = "project_master_id = #{params[:project_master_id]} "
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


puts "99999#{@search}"

	  @sprint_plannings = SprintPlanning.where("#{@search}")
	  resp=[]
     @sprint_plannings.each do |p| 
      
    
 
  if p.project_master_id!=nil
    puts "0000#{@search}"
      @project_master = ProjectMaster.find_by_id(p.project_master_id)
      if @project_master!=nil and @project_master!=""
        @project_id = @project_master.id
        @project_name =@project_master.project_name
      else
        @project_id = ""
        @project_name =""
      end
      if p.project_master_id!=nil and p.release_planning_id !=nil
            @release_planning = ReleasePlanning.where("project_master_id = #{p.project_master_id} and id = #{p.release_planning_id}").first

            if @release_planning!=nil and @release_planning!=""
              @release_name =@release_planning.release_name
              @release_id =@release_planning.id
            else
              @release_id = ""
              @release_name =""
            end
          end
          else
            release_name =""
            puts "---------@release_name-----------"
      end
      if p.sprint_status_id.to_i != 0
        @status = SprintStatus.find_by_id(p.sprint_status_id)
        @status_name = @status.status
      else
        @status_name = ""
      end

      @sprint_planning_reason = SprintPlanningReason.find_by_sprint_planning_id(p.id)
      if @sprint_planning_reason!=nil and @sprint_planning_reason!=""
        @date_reason =@sprint_planning_reason.date_reason
        @hour_reason =@sprint_planning_reason.hour_reason
      else
        @date_reason =""
        @hour_reason =""
      end

      resp << {
        'id' => p.id,
        'project_master_id' => @project_id,
        'project_name' => @project_name,
        'release_planning_id' => @release_id,
        'release_name' => @release_name,
        'sprint_name' => p.sprint_name,
        'sprint_status_id' => p.sprint_status_id,
        'status_name' => @status_name,
        'start_date' => p.start_date,        
        'end_date' => p.end_date,
        'planned_hours' => p.planned_hours,
        'actual_hours'   => p.actual_hours,
        'sprint_desc' => p.sprint_desc,
        'date_reason' => @date_reason,
        'hour_reason' => @hour_reason
        }
      end
    #pagination(SprintPlanning,@search)
    
    response = {
      #'no_of_records' => @no_of_records.size,
      #'no_of_pages' => @no_pages,
      #'next' => @next,
      #'prev' => @prev,
      'project' => @project_resp,
      'list' => resp,
      'count' => resp.count

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
            if params[:task_reason]|| params[:hour_reason].present?
              @sprint_reason = SprintPlanningReason.new
                    @sprint_reason.sprint_planning_id = @sprint_planning.id
                    @sprint_reason.date_reason = params[:date_reason]
                    @sprint_reason.hour_reason = params[:hour_reason]
                    @sprint_reason.created_by = params[:user_id]
                    @sprint_reason.project_master_id = @sprint_planning.project_master_id
              @sprint_reason.save
            end
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
      raw_parameters = { :active => "#{params[:active]}", :start_date => "#{params[:start_date]}", :end_date => "#{params[:end_date]}", :sprint_name => "#{params[:sprint_name]}", :sprint_desc => "#{params[:sprint_desc]}", :sprint_status_id => "#{params[:sprint_status_id]}", :release_planning_id => "#{params[:release_planning_id]}", :project_master_id => "#{params[:project_master_id]}", :planned_hours => "#{params[:planned_hours]}", :actual_hours => "#{params[:actual_hours]}", :sc_start => "#{params[:sc_start]}", :sc_end => "#{params[:sc_end]}", :delay_type => "#{params[:delay_type]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit( :active, :start_date, :end_date, :sprint_name, :sprint_desc, :sprint_status_id, :project_master_id, :release_planning_id, :planned_hours, :actual_hours, :sc_start, :sc_end, :delay_type)
    end

end
