class Api::V1::ReleasePlanningsController < ApplicationController

before_action :authenticate_user!
before_action :set_planning, only: [:show, :edit, :update]

	 def index

 get_all_projects

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

       resp << {
        'id' => t.id,
        'release_name' => t.release_name,
        'start_date' => t.start_date,
        'end_date' => t.end_date,        
        'release_notes' => t.release_notes,        
        'user_id' => t.user_id, 
        'active' => t.active, 
        'flag_name' => t.flag_name,
        'project_name' => @project_name,
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
      raw_parameters = { :release_name => "#{params[:release_name]}", :start_date => "#{params[:start_date]}", :end_date => "#{params[:end_date]}", :comments => "#{params[:comments]}",:active => "#{params[:active]}", :release_notes => "#{params[:release_notes]}", :approved => "#{params[:approved]}", :approved_by_user_id => "#{params[:approved_by_user_id]}", :qa_approved => "#{params[:qa_approved]}", :qa_approved_by_user_id => "#{params[:qa_approved_by_user_id]}", :qa_approved_date_time => "#{params[:qa_approved_date_time]}", :user_id => "#{params[:user_id]}", :project_master_id => "#{params[:project_master_id]}", :flag_name => "#{params[:flag_name]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:release_name, :start_date, :end_date, :comments, :active, :release_notes, :approved, :approved_by_user_id, :qa_approved, :qa_approved_by_user_id,:qa_approved_date_time, :user_id, :project_master_id, :flag_name)    
    end
end
