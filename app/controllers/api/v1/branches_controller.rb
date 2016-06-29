class Api::V1::BranchesController < ApplicationController

before_action :authenticate_user!
before_action :set_branch, only: [:show, :edit, :update]


def index

      #search
        if params[:search]!=nil and params[:search]!=""
          @search ="id = #{params[:search]}"
        else
          @search =""
        end
        #search

    @branches = Branch.where("#{@search}").page(params[:page]).order(:id)

   resp=[]
     @branches.each do |b| 
      resp << {
        'id' => b.id,
        'branch_name' => b.name,
        'active' => b.active,
      }
      end

    pagination(Branch,@search)
    get_all_branch

    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'branch_list' => @branch_resp,
      'branch_resp' => resp

    }
  render json: response 
end

def show	
   render json: @branch
end

def create

    @branch = Branch.new(branch_params)
    if @branch.save
      @branch.active = params[:active]
        @branch.save
      render json: { valid: true, msg:"#{@branch.name} created successfully."}  
      #index
    else
      render json: { valid: false, error: @branch.errors }, status: 404
    end    
  end

 def update
    if @branch.update(branch_params)
      @branch.active = params[:active]
        @branch.save
       render json: { valid: true, msg:"#{@branch.name} updated successfully."}
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

      raw_parameters = { :name => "#{params[:name]}", :user_id => "#{params[:user_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:name, :active, :user_id)
    
    end



end
