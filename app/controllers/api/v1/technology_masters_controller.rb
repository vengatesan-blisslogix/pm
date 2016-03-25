class Api::V1::TechnologyMastersController < ApplicationController


before_action :authenticate_user!
before_action :set_tech, only: [:show, :edit, :update]



 def index
	if params[:page] && params[:per]
	  @technlogies = TechnologyMaster.page(params[:page]).per(params[:per])
	else
	  @technlogies = TechnologyMaster.limit(10)
	end
	  render json: @technlogies     
 end

def show	
   render json: @technology
end

def create

    @technology = TechnologyMaster.new(technology_params)
    if @technology.save
    	index
     else
        render json: { valid: false, error: @technology.errors }, status: 404
     end
    
end

 def update   

    if @technology.update(technology_params)  	      
       render json: @technology
     else
        render json: { valid: false, error: @technology.errors }, status: 404
     end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_tech
      @technology = TechnologyMaster.find_by_id(params[:id])
      if @technology
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def technology_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :technology => "#{params[:technology]}", :active => "#{params[:active]}", :user_id => "#{params[:user_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:technology, :active, :user_id)
    
    end


end
