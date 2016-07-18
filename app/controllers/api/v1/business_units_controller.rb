class Api::V1::BusinessUnitsController < ApplicationController

before_action :authenticate_user!
before_action :set_business, only: [:show, :edit, :update]

def index
#search
        if params[:search]!=nil and params[:search]!=""
          @search ="id = #{params[:search]}"
        else
          @search =""
        end
        #search

    @business_units = BusinessUnit.where("#{@search}").page(params[:page]).order(:created_at => 'desc')
    resp=[]
     @business_units.each do |bu| 
      resp << {
        'id' => bu.id,
        'name' => bu.name,
        'active' => bu.active,
        'description' => bu.description
      }
      end

    pagination(BusinessUnit,@search)
    get_all_business
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'business_list' => @business_resp,
      'business_resp' => resp

    }
  render json: response
 
end

def show	
   render json: @business_unit
end

def create

    @business_unit = BusinessUnit.new(business_params)
    if @business_unit.save
            @business_unit.active = "active"
        @business_unit.save
    	render json: { valid: true, msg:"#{@business_unit.name} created successfully."}  
      #index
    else
      render json: { valid: false, error: @business_unit.errors }, status: 404
    end    
  end

 def update   

    if @business_unit.update(business_params)  	      
       render json: { valid: true, msg:"#{@business_unit.name} updated successfully."}
    else
        render json: { valid: false, error: @business_unit.errors }, status: 404
    end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_business
      @business_unit = BusinessUnit.find_by_id(params[:id])
      if @business_unit
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def business_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :name => "#{params[:name]}", :active => "#{params[:active]}", :user_id => "#{params[:user_id]}", :description => "#{params[:description]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:name, :active, :description, :user_id)
    
    end

end
