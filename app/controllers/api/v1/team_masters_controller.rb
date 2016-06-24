class Api::V1::TeamMastersController < ApplicationController

before_action :authenticate_user!
before_action :set_team, only: [:show, :edit, :update]



 def index
	if params[:page] && params[:per]
	  @teams = TeamMaster.page(params[:page]).per(params[:per])
	else
	  @teams = TeamMaster.limit(10)
	end
	  render json: @teams  
 end

def show	
   render json: @team
end

def create

    @team = TeamMaster.new(team_params)
    if @team.save
    	render json: { valid: true, msg:"#{@team.team_name} created successfully."}  
      #index
    else
      render json: { valid: false, error: @team.errors }, status: 404
    end    
  end

 def update   

    if @team.update(team_params)  	      
       render json: @team
     else
        render json: { valid: false, error: @team.errors }, status: 404
     end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = TeamMaster.find_by_id(params[:id])
      if @team
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :team_name => "#{params[:team_name]}", :description => "#{params[:description]}", :active => "#{params[:active]}", :user_id => "#{params[:user_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:team_name, :description, :active, :user_id)
    
    end


end
