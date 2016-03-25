class Api::V1::ReleasePlanningsController < ApplicationController

before_action :authenticate_user!
before_action :set_planning, only: [:show, :edit, :update]

	 def index
		if params[:page] && params[:per]
		  @release_plannings = ReleasePlanning.page(params[:page]).per(params[:per])
		else
		  @release_plannings = ReleasePlanning.limit(10)
		end
		  render json: @release_plannings     
	 end

	  def show	
	     render json: @release_planning
	  end

	def create
	  @release_planning = ReleasePlanning.new(planning_params)
		if @release_planning.save
			index
		else
		    render json: { valid: false, error: @release_planning.errors }, status: 404
		end    
	end

	def update 
	    if @release_planning.update(planning_params)  	      
	       render json: @release_planning
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
      raw_parameters = { :release_name => "#{params[:release_name]}", :start_date => "#{params[:start_date]}", :end_date => "#{params[:end_date]}", :comments => "#{params[:comments]}",:active => "#{params[:active]}", :release_notes => "#{params[:release_notes]}", :approved => "#{params[:approved]}", :approved_by_user_id => "#{params[:approved_by_user_id]}", :qa_approved => "#{params[:qa_approved]}", :qa_approved_by_user_id => "#{params[:qa_approved_by_user_id]}", :qa_approved_date_time => "#{params[:qa_approved_date_time]}", :user_id => "#{params[:user_id]}", :project_id => "#{params[:project_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:release_name, :start_date, :end_date, :comments, :active, :release_notes, :approved, :approved_by_user_id, :qa_approved, :qa_approved_by_user_id,:qa_approved_date_time, :user_id, :project_id)    
    end
end
