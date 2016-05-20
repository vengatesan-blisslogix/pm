class Api::V1::TimesheetsController < ApplicationController

before_action :authenticate_user!
before_action :set_timesheet, only: [:show, :edit, :update]


def index
  if params[:page] && params[:per]
	@timesheets = Timesheet.page(params[:page]).per(params[:per])
  else
	@timesheets = Timesheet.limit(10)
  end
	render json: @timesheets
end

def show	
   render json: @timesheet
end

def create
  begin          
    if params[:project_master_id]!=nil and params[:project_master_id]!=""
      convert_param_to_array(params[:project_master_id])
      @pm_id = @output_array
      convert_param_to_array(params[:task_date])
      @t_date = @output_array
      convert_param_to_array(params[:task_time])
      @t_time = @output_array

          p=0
          @t_date.each do |user|
            @timesheet = Timesheet.new
            @timesheet.task_date = @t_date[p]
            @timesheet.task_time = @t_time[p]
            @timesheet.project_task_id = params[:project_task_id]
            @timesheet.project_master_id = params[:project_master_id]
            @timesheet.user_id = params[:user_id]

          
            @timesheet.save!
             p=p+1
          end
      render json: { valid: true, msg: "timesheet created successfully."}
    else
      render json: { valid: false, error: "Invalid parameters" }, status: 404
    end
  rescue
      render json: { valid: false, error: "Invalid parameters" }, status: 404
  end    
end

 def update 
    if @timesheet.update(timesheet_params)  	      
        render json: { valid: true, msg:"timesheet updated successfully."}
     else
        render json: { valid: false, error: @timesheet.errors }, status: 404
     end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_timesheet
      @timesheet = Timesheet.find_by_id(params[:id])
      if @timesheet
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def timesheet_params
        raw_parameters = { :project_master_id => "#{params[:project_master_id]}", :project_task_id => "#{params[:project_task_id]}", :user_id => "#{params[:user_id]}", :task_date => "#{params[:task_date]}", :task_time => "#{params[:task_time]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:project_master_id, :project_task_id, :user_id, :task_date, :task_time)
    
    end

end
