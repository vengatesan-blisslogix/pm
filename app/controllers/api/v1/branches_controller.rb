class Api::V1::BranchesController < ApplicationController

before_action :authenticate_user!
before_action :set_branch, only: [:show, :edit, :update]



 def index
  if params[:page] && params[:per]
    @branchs = Branch.page(params[:page]).per(params[:per])
  else
    @branchs = Branch.limit(10)
  end
     render json: @branchs 
    
 end

def show	
   render json: @branch
end

def create

    @branch = Branch.new(branch_params)
    if @branch.save
    	index
     else
        render json: { valid: false, error: @branch.errors }, status: 404
     end
    
end

 def update   

    if @branch.update(branch_params)  	      
       render json: @branch
     else
        render json: { valid: false, error: @branch.errors }, status: 404
     end
  end
private

    # Use callbacks to share common setup or constraints between actions.
    def set_branch
      @branch = Branch.find_by_id(params[:id])
      if @branch
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def branch_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :name => "#{params[:name]}", :active => "#{params[:active]}", :user_id => "#{params[:user_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:name, :active, :user_id)
    
    end



end
