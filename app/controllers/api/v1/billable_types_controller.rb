class Api::V1::BillableTypesController < ApplicationController

before_action :authenticate_user!
before_action :set_billable, only: [:show, :edit, :update]

def index
      #search
        #if params[:search]!=nil and params[:search]!=""
          #@search ="id = #{params[:search]}"
        #else
          #@search =""
        #end
        #search

    @billable_types = BillableType.where("#{@search}").page(params[:page]).order(:created_at => 'desc')
   resp=[]
     @billable_types.each do |b| 
      resp << {
        'id' => b.id,
        'name' => b.name,
        'active' => b.active,
        'description' => b.description
      }
      end

    pagination(BillableType,@search)
   # get_all_team

    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
     # 'team_list' => @team_resp,
      'billable_resp' => resp

    }
  render json: response 
end

def show	
   render json: @billable_type
end

def create

    @billable_type = BillableType.new(billable_params)
    if @billable_type.save
      @billable_type.active = "active"
        @billable_type.save
    	render json: { valid: true, msg:"#{@billable_type.name} created successfully."}  
      #index
    else
      render json: { valid: false, error: @billable_type.errors }, status: 404
    end    
  end

 def update   

    if @billable_type.update(billable_params)  	      
       render json:{ valid: true, msg:"#{@billable_type.name} updated successfully."}
     else
        render json: { valid: false, error: @billable_type.errors }, status: 404
     end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_billable
      @billable_type = BillableType.find_by_id(params[:id])
      if @billable_type
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def billable_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :name => "#{params[:name]}", :description => "#{params[:description]}", :active => "#{params[:active]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:name, :description, :active)
    
    end


end
