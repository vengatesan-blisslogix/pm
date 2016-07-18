class Api::V1::EngagementTypesController < ApplicationController

before_action :authenticate_user!
before_action :set_engagement, only: [:show, :edit, :update]

def index
#search
        if params[:search]!=nil and params[:search]!=""
          @search ="id = #{params[:search]}"
        else
          @search =""
        end
        #search

    @engagement_types = EngagementType.where("#{@search}").page(params[:page]).order(:created_at => 'desc')
    resp=[]
     @engagement_types.each do |et| 
      resp << {
        'id' => et.id,
        'name' => et.name,
        'active' => et.active,
        'description' => et.description
      }
      end

    pagination(EngagementType,@search)
    get_all_engagement
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'engagement_list' => @engagement_resp,
      'engagement_resp' => resp

    }
  render json: response
 
end

def show	
   render json: @engagement_type
end

def create

    @engagement_type = EngagementType.new(engagement_params)
    if @engagement_type.save
            @engagement_type.active = "active"
        @engagement_type.save
    	render json: { valid: true, msg:"#{@engagement_type.name} created successfully."}  
      #index
    else
      render json: { valid: false, error: @engagement_type.errors }, status: 404
    end    
  end

 def update   

    if @engagement_type.update(engagement_params)  	      
       render json: { valid: true, msg:"#{@engagement_type.name} updated successfully."}
    else
        render json: { valid: false, error: @engagement_type.errors }, status: 404
    end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_engagement
      @engagement_type = EngagementType.find_by_id(params[:id])
      if @engagement_type
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def engagement_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :name => "#{params[:name]}", :active => "#{params[:active]}", :user_id => "#{params[:user_id]}", :description => "#{params[:description]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:name, :active, :description, :user_id)
    
    end

end
