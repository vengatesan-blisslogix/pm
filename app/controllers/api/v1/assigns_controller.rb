class Api::V1::AssignsController < ApplicationController


before_action :authenticate_user!
before_action :set_assign, only: [:show, :edit, :update]

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

    @assign = Assign.new(assign_params)
    if @assign.save
    	render json: { valid: true, msg:"assign created successfully."}
     else
        render json: { valid: false, error: @assign.errors }, status: 404
     end
    
end

 def update   

    if @assign.update(assign_params)  	      
       render json: { valid: true, msg:"assign updated successfully."}
     else
        render json: { valid: false, error: @assign.errors }, status: 404
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

      raw_parameters = { :taskboard_id => "#{params[:taskboard_id]}", :assigned_user_id => "#{params[:assigned_user_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:taskboard_id, :assigned_user_id)
    
    end

end
