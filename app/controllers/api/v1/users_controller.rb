class Api::V1::UsersController < ApplicationController


before_action :authenticate_user!
before_action :set_user, only: [:show, :edit, :update]



 def index

    @users = User.page(params[:page]).order(:id)


     #render json: @users 
     resp=[]
     @users.each do |u| 
          @role = RoleMaster.find_by_id(u.role_master_id)
          if @role!=nil and @role!=""
          @role = @role.role_name
          else
          @role =""
          end

          @reporting_to = User.find_by_id(u.reporting_to)
          if @reporting_to!=nil and @reporting_to!=""
          @reporting_to = @reporting_to.name
          else
          @reporting_to =""
          end
 
          @branch = Branch.find_by_id(u.branch_id)
          if @branch!=nil and @branch!=""
          @branch = @branch.name
          else
          @branch =""
          end

          if u.active.to_i==1
          @status=true
          else
          @status=false
          end
      resp << {
        'id' => u.id,
        'first_name' => u.name,
        'last_name' => u.last_name,
        'email' => u.email,
        'role' =>@role,
        'reporting_to' =>@reporting_to,
        'project_assigned' =>"",
        'branch' =>@branch,
        'status' =>@status
      
      }
      end
      
    pagination(User)
    
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'roles' => resp
    }

    render json: response
    
 end

def show	
   render json: @user
end

 def update   
    if @user.update(user_params) 	      
       render json: @user
     else
        render json: { valid: false, error: @user.errors }, status: 404
     end
  end



private


    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by_id(params[:id])
      if @user
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :active, :user_id)
    end


end
