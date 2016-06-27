class Api::V1::TechnologyMastersController < ApplicationController

before_action :authenticate_user!
before_action :set_tech, only: [:show, :edit, :update]

def index
   @technlogies = TechnologyMaster.page(params[:page]).order(:id)
   resp=[]
     @technlogies.each do |t| 
      resp << {
        'id' => t.id,
        'technology' => t.technology,
        'active' => t.active,
        'description' => t.description
      }
      end

    pagination(TechnologyMaster,@search_value)
    
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'technology_resp' => resp

    }
  render json: response
 
end

def show	
   render json: @technology
end

def create

    @technology = TechnologyMaster.new(technology_params)
    if @technology.save
            @technology.active = "active"
        @technology.save
    	render json: { valid: true, msg:"#{@technology.technology} created successfully."}  
      #index
    else
      render json: { valid: false, error: @@technology.errors }, status: 404
    end    
  end

 def update   

    if @technology.update(technology_params)  	      
       render json: { valid: true, msg:"#{@technology.technology} updated successfully."}
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

      raw_parameters = { :technology => "#{params[:technology]}", :active => "#{params[:active]}", :user_id => "#{params[:user_id]}", :description => "#{params[:description]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:technology, :active, :description, :user_id)
    
    end


end
