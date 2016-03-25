class Api::V1::ProjectTimeSheetsController < ApplicationController


#before_action :authenticate_user!
before_action :set_time_sheet, only: [:show, :edit, :update]

 def index
	if params[:page] && params[:per]
	  @time_sheets = ProjectTimeSheet.page(params[:page]).per(params[:per])
	else
	  @time_sheets = ProjectTimeSheet.limit(10)
	end
	  render json: @time_sheets  
 end

def show	
   render json: @time_sheet
end

def create

    @time_sheet = ProjectTimeSheet.new(time_sheet_params)
    if @time_sheet.save
    	index
     else
        render json: { valid: false, error: @time_sheet.errors }, status: 404
     end
    
end

 def update   

    if @time_sheet.update(time_sheet_params)  	      
       render json: @time_sheet
     else
        render json: { valid: false, error: @time_sheet.errors }, status: 404
     end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_time_sheet
      @time_sheet = ProjectTimeSheet.find_by_id(params[:id])
      if @time_sheet
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def time_sheet_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :duration_in_hours => "#{params[:duration_in_hours]}", :date_time => "#{params[:datetime]}", :comments => "#{params[:comments]}",  :timesheet_status => "#{params[:timesheet_status]}", :approved_by => "#{params[:approved_by]}",  :project_id => "#{params[:project_id]}", :task_id => "#{params[:task_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:duration_in_hours, :date_time, :comments, :timesheet_status, :approved_by, :project_id, :task_id)
    
    end


end
