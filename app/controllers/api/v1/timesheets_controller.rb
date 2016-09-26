class Api::V1::TimesheetsController < ApplicationController

before_action :authenticate_user!
before_action :set_timesheet, only: [:show, :edit, :update]


def index
  if params[:page] && params[:per]
	@timesheets = Logtime.page(params[:page]).per(params[:per])
  else
	@timesheets = Logtime.limit(20)
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
      convert_param_to_array(params[:sprint_planning_id])
      @sp_id = @output_array
      convert_param_to_array(params[:task_master_id])
      @proj_task = @output_array
puts"@pm_id---------#{@pm_id}"
          p=0
          @pm_id.each do |pid|
        puts"@pm_id---pidpidpid------#{pid}"               

                if params[:task_date] and params[:task_time]
                @task_d = params[:task_date].split("//")[p]
                convert_param_to_array(@task_d)
                @t_date = @output_array
                @task_t = params[:task_time].split("//")[p]
                convert_param_to_array(@task_t)
                @t_time = @output_array
                t=0

                @t_date.each do |td|

                  @timesheet = Logtime.new
                  @timesheet.start_time  = params[:start_time]
                  @timesheet.end_time  = params[:end_time]
                  @timesheet.date  = params[:date]
                  @timesheet.task_master_id  = @proj_task[p]
                  @timesheet.project_master_id = pid
                  @timesheet.sprint_planning_id = @sp_id[p]

                  #@timesheet.taskboard_id = params[:taskboard_id]
                  @timesheet.user_id = params[:user_id]
                  @timesheet.status = "pending"
                  @timesheet.task_date = @t_date[t]
                  @timesheet.task_time = @t_time[t]                 
                  @timesheet.save!

                  t=t+1
                end#@t_date.each do |td|
              end#if params[:task_date] and params[:task_time]
              p=p+1
             
           
          end#@pm_id.each do |pid|

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
      @timesheet = Logtime.find_by_id(params[:id])
      if @timesheet
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def timesheet_params
        raw_parameters = { :project_master_id => "#{params[:project_master_id]}", :task_master_id  => "#{params[:project_task_id]}", :sprint_planning_id => "#{params[:sprint_planning_id]}", :user_id => "#{params[:user_id]}", :task_date => "#{params[:task_date]}", :task_time => "#{params[:task_time]}", :start_time => "#{params[:start_time]}", :end_time => "#{params[:end_time]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit( :sprint_planning_id, :project_master_id, :task_master_id, :user_id, :task_date, :task_time, :start_time, :end_time)
    
    end

end
