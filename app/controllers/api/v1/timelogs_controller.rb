class Api::V1::TimelogsController < ApplicationController


before_action :authenticate_user!
before_action :set_timelog, only: [:show, :edit, :update]

def index
  if params[:page] && params[:per]
	@timelogs = Logtime.page(params[:page]).per(params[:per])
  else
	@timelogs = Logtime.limit(10)
  end
	render json: @timelogs
end

def show	
   render json: @timelog
end

def create

    @timelog = Logtime.new(timelog_params)
    if @timelog.save
          @timelog.task_date = params[:date]
          @timelog.task_time = ((@timelog.end_time  - @timelog.start_time) / 1.hour)

          @timelog.user_id = params[:user_id]
       @timelog.save
    	render json: { valid: true, msg:"timelog created successfully."}
     else
        render json: { valid: false, error: @timelog.errors }, status: 404
     end
    
end

 def update   

    if @timelog.update(timelog_params)  	      
       render json: { valid: true, msg:"timelog updated successfully."}
     else
        render json: { valid: false, error: @timelog.errors }, status: 404
     end
  end

def destroy
	
end

private

    # Use callbacks to share common setup or constraints between actions.
    def set_timelog
      @timelog = Logtime.find_by_id(params[:id])
      if @timelog
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def timelog_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :date => "#{params[:date]}", :start_time => "#{params[:start_time]}", :end_time => "#{params[:end_time]}", :taskboard_id => "#{params[:taskboard_id]}", :task_master_id => "#{params[:task_master_id]}", :project_master_id => "#{params[:project_master_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:date, :start_time, :end_time, :taskboard_id, :task_master_id, :project_master_id)
    
    end


end
