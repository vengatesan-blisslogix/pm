class Api::V1::ReleasePlanningsController < ApplicationController

before_action :authenticate_user!
before_action :set_planning, only: [:show, :edit, :update]

	 def index

 get_all_projects

      if params[:project_master_id] 
        @search = "project_master_id = #{params[:project_master_id]}"
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


puts "#{@search}"

    @release_plannings = ReleasePlanning.where(@search).page(params[:page]).order(:created_at => 'desc')
    resp=[]
     @release_plannings.each do |t| 
    

      if t.project_master_id!=nil

        @project_master = ProjectMaster.find_by_id(t.project_master_id)
          if @project_master!=nil and @project_master!=""
            @project_name =@project_master.project_name
          else
            @project_name =""
          end
        elsif params[:project_master_id]
          @project_name = ProjectMaster.find_by_id(params[:project_master_id]).project_name
          
      end

     if t.sprint_status_id.to_i != 0
        @status = SprintStatus.find_by_id(t.sprint_status_id)
        @status_name = @status.status
      else
        @status_name = ""
      end

      @release_planning_reason = ReleasePlanningReason.find_by_release_planning_id(t.id)
      if @release_planning_reason!=nil and @release_planning_reason!=""
        @date_reason =@release_planning_reason.date_reason
        @hour_reason =@release_planning_reason.hour_reason
      else
        @date_reason =""
        @hour_reason =""
      end

       resp << {
        'id' => t.id,
        'release_name' => t.release_name,
        'start_date' => t.start_date,
        'end_date' => t.end_date,
        'planned_hours' => t.planned_hours,
        'actual_hours'   => t.actual_hours,
        'release_notes' => t.release_notes,        
        'active' => t.active, 
        'flag_name' => t.flag_name,
        'sprint_status_id' => t.sprint_status_id,
        'status_name' => @status_name,
        'project_master_id' => t.project_master_id,
        'project_name' => @project_name,
        'date_reason' => @date_reason,
        'hour_reason' => @hour_reason,
        'sc_start' => t.sc_start,
        'sc_end' => t.sc_end,
        'delay_type' => t.delay_type
      }      
    end   
    pagination(ReleasePlanning,@search)
    
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
	     render json: @release_planning, status: 200
	  end

	def create
	  @release_planning = ReleasePlanning.new(planning_params)
		if @release_planning.save
       @release_planning.active = "active"
        @release_planning.save

			render json: { valid: true, msg:"#{@release_planning.release_name} created successfully."}	
		else
		  render json: { valid: false, msg: @release_planning.errors }, status: 404
		end    
	end

	def update 
	    if @release_planning.update(planning_params)
         if params[:task_reason]|| params[:hour_reason].present?
              @release_reason = ReleasePlanningReason.new
                    @release_reason.release_planning_id = @release_planning.id
                    @release_reason.date_reason = params[:date_reason]
                    @release_reason.hour_reason = params[:hour_reason]
                    @release_reason.created_by = params[:user_id]
                    @release_reason.project_master_id = @release_planning.project_master_id
              @release_reason.save
         end
         render json: { valid: true, msg:"#{@release_planning.release_name} updated successfully."}
	    else
	       render json: { valid: false, error: @release_planning.errors }, status: 404
	    end
	end


private

    def set_planning
      @release_planning = ReleasePlanning.find_by_id(params[:id])
      if @release_planning
      else
      	render json: { valid: false}, status: 404
      end
    end

    def planning_params
      raw_parameters = { :release_name => "#{params[:release_name]}", :start_date => "#{params[:start_date]}", :end_date => "#{params[:end_date]}", :comments => "#{params[:comments]}",:active => "#{params[:active]}", :release_notes => "#{params[:release_notes]}", :approved => "#{params[:approved]}", :approved_by_user_id => "#{params[:approved_by_user_id]}", :qa_approved => "#{params[:qa_approved]}", :qa_approved_by_user_id => "#{params[:qa_approved_by_user_id]}", :qa_approved_date_time => "#{params[:qa_approved_date_time]}", :user_id => "#{params[:user_id]}", :project_master_id => "#{params[:project_master_id]}", :flag_name => "#{params[:flag_name]}", :planned_hours => "#{params[:planned_hours]}", :actual_hours => "#{params[:actual_hours]}", :sprint_status_id => "#{params[:sprint_status_id]}", :sc_start => "#{params[:sc_start]}", :sc_end => "#{params[:sc_end]}", :delay_type => "#{params[:delay_type]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:release_name, :start_date, :end_date, :comments, :active, :release_notes, :approved, :approved_by_user_id, :qa_approved, :qa_approved_by_user_id,:qa_approved_date_time, :user_id, :project_master_id, :flag_name, :planned_hours, :actual_hours, :sprint_status_id, :sc_start, :sc_end, :delay_type)    
    end
end
