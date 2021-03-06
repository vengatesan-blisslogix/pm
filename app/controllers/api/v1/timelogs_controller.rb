class Api::V1::TimelogsController < ApplicationController


before_action :authenticate_user!
before_action :set_timelog, only: [:show, :edit, :update]

def index
  if params[:page] && params[:per]
	@timelogs = Logtime.page(params[:page]).per(params[:per])
  else
	@timelogs = Logtime.limit(20)
  end
	render json: @timelogs
end

def show	
   render json: @timelog
end

def create

@timesheet_check = Logtime.where("task_master_id =#{params[:task_master_id]} and task_date = '#{params[:date].to_date}' and user_id = #{params[:user_id]}")
puts"-----#{params[:task_master_id]}----#{params[:date].to_date}---#{params[:user_id]}--"
           
                if @timesheet_check != nil and @timesheet_check.size != 0 
                  @timelog = @timesheet_check[0]
                else
                  @timelog = Logtime.new(timelog_params)
                end

    if @timelog.save
          @timelog.task_date = params[:date]
          @timelog.taskboard_id =  params[:id]
          if params[:task_time] and params[:task_time]!=nil
            @timelog.task_time = params[:task_time]
          else
            if @timelog.end_time!=nil and @timelog.start_time!=nil
            @timelog.task_time = ((@timelog.end_time  - @timelog.start_time) / 1.hour)
          end
          end  
  
          @timelog.user_id = params[:user_id]
          @timelog.status = "pending"
        @timelog.save

            if params[:assign] != nil and params[:assign].to_i == 1 and params[:assigned_user_id].present?
              #convert_param_to_array(params[:assigned_user_id])
             @assigned_user_id = params[:assigned_user_id]
                p=0
                  @assigned_user_id.each do |user|
                    
                    @find_user = Assign.where("taskboard_id = #{params[:id]} and assigned_user_id = #{user}")

                     puts "---del-2222222---#{@find_user.size}-----finduser---#{user}----#{params[:id]}-------id---@find_user[0].id-"
                      if @find_user != nil and @find_user.size != 0

                      else
                        @assign = Assign.new                      
                        @assign.taskboard_id = params[:id]
                        @assign.assigned_user_id = user
                        @assign.assigneer_id = params[:user_id]
                        @assign.track_id = params[:user_id]
                        @assign.is_delete = 0
                        @assign.save!
                      end
                  end
              end   
              puts "---del-----#{@del}-----finduser---#{ params[:unassigned_user_id]}-----#{ params[:unassigned_user_id].class}--id---@find_user[0].id-"
            if params[:assign] != nil and params[:assign].to_i == 1 and params[:unassigned_user_id].present?   
              #convert_param_to_array(params[:unassigned_user_id])
              @unassigned_user_id = params[:unassigned_user_id]
                p=0
                  @unassigned_user_id.each do |user|
                    
                    @find_unassinged_user = Assign.where("taskboard_id = #{params[:id]} and assigned_user_id = #{user}")
                    puts "---del-11111----#{@find_unassinged_user.size}-----finduser---#{user}----#{params[:id]}-------id---@find_unassinged_user[0].id-"
                      if @find_unassinged_user != nil and @find_unassinged_user.size != 0
                        @del = Assign.find_by_id(@find_unassinged_user[0].id)
                        @del.is_delete = 1
                        @del.save!
                        #@del.destroy if @del != nil
                      else
                        
                      end
                  end
            end 

          log_values = []

          log_values << {
                  'taskboard_id' => @timelog.taskboard_id,
                  'task_time' => @timelog.task_time
                  }
              log_values={
                    'valid' => true, 
                    'time_log' => log_values,
                    'msg' => "created successfully"
                    }

                  render json: log_values

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

      raw_parameters = { :date => "#{params[:date]}", :start_time => "#{params[:start_time]}", :end_time => "#{params[:end_time]}", :taskboard_id => "#{params[:taskboard_id]}", :task_master_id => "#{params[:task_master_id]}", :project_master_id => "#{params[:project_master_id]}" , :sprint_planning_id => "#{params[:sprint_planning_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:date, :start_time, :end_time, :taskboard_id, :task_master_id, :project_master_id, :sprint_planning_id)
    
    end
end
