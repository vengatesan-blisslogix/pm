class Api::V1::SprintPlanningsController < ApplicationController

before_action :authenticate_user!
before_action :set_sprint, only: [:show, :edit, :update]

	def index
	  if params[:page] && params[:per]
	    @sprint_plannings = SprintPlanning.page(params[:page]).per(params[:per])
	  else
		@sprint_plannings = SprintPlanning.limit(10)
	  end
		render json: @sprint_plannings     
	end

	def show	
	  render json: @sprint_planning
	end

	def create
	  @sprint_planning = SprintPlanning.new(sprint_params)
	    if @sprint_planning.save
		  index
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
      raw_parameters = { :active => "#{params[:active]}", :start_date => "#{params[:start_date]}", :end_date => "#{params[:end_date]}", :sprint_name => "#{params[:sprint_name]}", :sprint_desc => "#{params[:sprint_desc]}", :sprint_status_id => "#{params[:sprint_status_id]}", :release_id => "#{params[:release_id]}", :project_id => "#{params[:project_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit( :active, :start_date, :end_date, :sprint_name, :sprint_desc, :sprint_status_id, :project_id, :release_id)
    end

end
