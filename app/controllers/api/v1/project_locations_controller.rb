class Api::V1::ProjectLocationsController < ApplicationController

before_action :authenticate_user!
before_action :set_location, only: [:show, :edit, :update]

def index
#search
        if params[:search]!=nil and params[:search]!=""
          @search ="id = #{params[:search]}"
        else
          @search =""
        end
        #search

    @project_locations = ProjectLocation.where("#{@search}").page(params[:page]).order(:created_at => 'desc')
    resp=[]
     @project_locations.each do |pl| 
      resp << {
        'id' => pl.id,
        'name' => pl.name,
        'active' => pl.active,
        'description' => pl.description
      }
      end

    pagination(ProjectLocation,@search)
    get_all_location
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'location_list' => @location_resp,
      'location_resp' => resp

    }
  render json: response
 
end

def show	
   render json: @project_location
end

def create

    @project_location = ProjectLocation.new(location_params)
    if @project_location.save
            @project_location.active = "active"
        @project_location.save
    	render json: { valid: true, msg:"#{@project_location.name} created successfully."}  
      #index
    else
      render json: { valid: false, error: @project_location.errors }, status: 404
    end    
  end

 def update   

    if @project_location.update(location_params)  	      
       render json: { valid: true, msg:"#{@project_location.name} updated successfully."}
    else
        render json: { valid: false, error: @project_location.errors }, status: 404
    end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @project_location = ProjectLocation.find_by_id(params[:id])
      if @project_location
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :name => "#{params[:name]}", :active => "#{params[:active]}", :user_id => "#{params[:user_id]}", :description => "#{params[:description]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:name, :active, :description, :user_id)
    
    end

end
