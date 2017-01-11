class Api::V1::AssignsController < ApplicationController


before_action :authenticate_user!
#before_action :set_assign, only: [:show]

def index
  if params[:page] && params[:per]
  @assigns = Assign.page(params[:page]).per(params[:per])
  else
  @assigns = Assign.limit(20)
  end
  render json: @assigns
end

def show	
   render json: @assign
end

def create
  begin    
    if params[:assigned_user_id]!=nil and params[:assigned_user_id]!=""
      convert_param_to_array(params[:assigned_user_id])
      @assigned_user_id = @output_array
           p=0
      @assigned_user_id.each do |user|
      @assign = Assign.new
      @assign.taskboard_id = params[:taskboard_id]
      @assign.assigned_user_id = user
      @assign.assigneer_id = params[:user_id]
      @assign.save!
       p=p+1
     end
    end
    	render json: { valid: true, msg:"assign created successfully."}
    rescue
      render json: { valid: false, error: "Invalid parameters" }, status: 404
    end
    
end

 def update   

    begin    
    if params[:assigned_user_id]!=nil and params[:assigned_user_id]!=""

      Assign.destroy_all(:taskboard_id => params[:taskboard_id])
      convert_param_to_array(params[:assigned_user_id])
      @assigned_user_id = @output_array
           p=0
      @assigned_user_id.each do |user|
      @assign = Assign.new
      @assign.taskboard_id = params[:taskboard_id]
      @assign.assigned_user_id = user
      @assign.assigneer_id = params[:user_id]
      @assign.save!
       p=p+1
     end
    end
      render json: { valid: true, msg:"assign updated successfully."}
    rescue
      render json: { valid: false, error: "Invalid parameters" }, status: 404
    end
  end

def destroy
	
end

private

    # Use callbacks to share common setup or constraints between actions.
    def set_assign
      @assign = Assign.find_by_id(params[:id])
      if @assign
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def assign_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :taskboard_id => "#{params[:taskboard_id]}", :assigned_user_id => "#{params[:assigned_user_id]}", :assigneer_id => "#{params[:assigneer_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:taskboard_id, :assigned_user_id, :assigneer_id)
    
    end

end
