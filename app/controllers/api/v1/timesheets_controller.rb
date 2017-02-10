require 'json'

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

if params[:log].to_i == 1

  json = params[:_json].to_s.gsub("=>",":")

   puts "---------------#{json}------------------" 
    # Parse the JSON
    hash1 = JSON.parse(json)
    hash1.each do |hash|

  @project_id = hash['ProjectId']
  @release_id = hash['Release']['id']
  @sprint_id = hash['Release']['Sprints']['id']
  #puts"=========AAAAA======#{hash['ProjectId']}==RR==#{hash['Release']['id']}---=SS===#{hash['Release']['Sprints']['id']}"
    # Get the Hash we're interested in
    results = hash['Release']['Sprints']['Tasks']
    # Get the key names to use as headers
    headers = results[0].keys
    #puts"-headers---#{headers}-----"
      # Iterate over the "results" hashes
      results.each do |result|
        # Replace the "repository" hash with its "name" value
        
    @h = result['Timesheet'][0].keys
    @h1 = result['Timesheet']
    @task_id = result['id']
    #puts"-result.values_at(*headers)----------#{result.values_at(*headers)}--#{result['id']}---"
      @h1.each do |h|
        @task_date = h['Date']
        @task_time = h['hour'] 

            @timesheet_check = Logtime.find_by(task_master_id: @task_id, task_date: @task_date)
            puts "-----------#{@timesheet_check}----------------------"
                if @timesheet_check != nil 
                  @timesheet = timesheet_check
                else
                  @timesheet = Logtime.new
                
                    @timesheet.task_master_id  = @task_id
                    @timesheet.project_master_id = @project_id
                    @timesheet.sprint_planning_id = @sprint_id
                    @timesheet.user_id = params[:user_id]
                    @timesheet.status = "pending"
                    @timesheet.task_date = @task_date
                    @timesheet.task_time = @task_time                 
                    @timesheet.save!
                end
      end
    end
  end
        render json: { valid: true, msg: "timesheet created successfully."}

elsif params[:log].to_i == 2

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

                       @timesheet_check = Logtime.find_by(task_master_id: @proj_task[p], task_date: @t_date[t])
                       if @timesheet_check != nil 
                        @timesheet = timesheet_check
                       else
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
                      end#if @timesheet_check
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
  end#if
end

 def update 
   if params[:log].to_i == 1

  json = params[:_json].to_s.gsub("=>",":")


    # Parse the JSON
    puts "------------------#{json}------------------"    
    hash1 = JSON.parse(json)
    hash1.each do |hash|

  @project_id = hash['ProjectId']
  @release_id = hash['Release']['id']
  @sprint_id = hash['Release']['Sprints']['id']
  #puts"=========AAAAA======#{hash['ProjectId']}==RR==#{hash['Release']['id']}---=SS===#{hash['Release']['Sprints']['id']}"
    # Get the Hash we're interested in
    results = hash['Release']['Sprints']['Tasks']
    # Get the key names to use as headers
    headers = results[0].keys
    #puts"-headers---#{headers}-----"
      # Iterate over the "results" hashes
      results.each do |result|
        # Replace the "repository" hash with its "name" value
        
    @h = result['Timesheet'][0].keys
    @h1 = result['Timesheet']
    @task_id = result['id']
    #puts"-result.values_at(*headers)----------#{result.values_at(*headers)}--#{result['id']}---"
      @h1.each do |h|
        @task_date = h['Date']
        @task_time = h['hour'] 


        @timesheet = Logtime.find_by(task_master_id: @task_id, task_date: @task_date.to_date)
         if @timesheet != nil 

         else
          @timesheet = Logtime.new
         

          @timesheet.task_master_id  = @task_id
          @timesheet.project_master_id = @project_id
          @timesheet.sprint_planning_id = @sprint_id
          @timesheet.user_id = params[:user_id]
          @timesheet.status = "pending"
          @timesheet.task_date = @task_date
          @timesheet.task_time = @task_time                 
          @timesheet.save!
        end
      end
    end
  end
        render json: { valid: true, msg: "timesheet updated successfully."}

   elsif params[:log].to_i == 2

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

                    @timesheet = Logtime.find_by_id(params[:id])
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

        render json: { valid: true, msg: "timesheet updated successfully."}
      else
        render json: { valid: false, error: "Invalid parameters" }, status: 404
      end
    rescue
        render json: { valid: false, error: "Invalid parameters" }, status: 404
    end    
   end#if
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
