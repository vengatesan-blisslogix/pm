class Api::V1::UserTechnologiesController < ApplicationController


before_action :authenticate_user!
before_action :set_usertech, only: [:show, :edit, :update]



 def index
	if params[:page] && params[:per]
	  @user_technologies = UserTechnology.page(params[:page]).per(params[:per])
	else
	  @user_technologies = UserTechnology.limit(10)
	end
	  render json: @user_technologies     
 end

  def show	
     render json: @user_technology
  end

def create

    @user_technology = UserTechnology.new(usertech_params)
    if @user_technology.save
    	index
     else
        render json: { valid: false, error: @user_technology.errors }, status: 404
     end
    
end

 def update   

    if @user_technology.update(usertech_params)  	      
       render json: @user_technology
     else
        render json: { valid: false, error: @user_technology.errors }, status: 404
     end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_usertech
      @user_technology = UserTechnology.find_by_id(params[:id])
      if @user_technology
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def usertech_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :technology_master_id => "#{params[:technology_master_id]}", :user_id => "#{params[:user_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:technology_master_id, :user_id)
    
    end


end
