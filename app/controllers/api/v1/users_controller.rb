class Api::V1::UsersController < ApplicationController


before_action :authenticate_user!
before_action :set_user, only: [:show, :edit, :update]



 def index
  if params[:page] && params[:per]
    @users = User.page(params[:page]).per(params[:per])
  else
    @users = User.limit(10)
  end

     #render json: @users 
     resp=[]
     @users.each do |u| 
      resp << {
        'id' => u.id,
        'name' => u.name,
        'nickname' => u.nickname,
        'email' => u.email,
        'mobile_no' => u.mobile_no,
        'office_phone' => u.office_phone,
        'home_phone' => u.home_phone,
        'prior_experience' => u.prior_experience,
        'doj' => u.doj,
        'dob' => u.dob
      }
      end
    render json: resp
    
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

def add_edit_user
      
      resp << {
        'company' => getcompany,
        'role' => getrole,
        'branch' => getbranch,
        'reporting_to' => getreporting_to,
        'team' => getteam,
        'technology' => gettech      
      }
     
    render json: resp
end

private

def getcompany
  resp = []
    @value = Company.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'company_name' => v.company_name
      }
    end
    resp
end

def getrole
  resp = []
    @value = RoleMaster.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'role_name' => v.role_name
      }
    end
    resp
end

def getreporting_to
  resp = []
    @value = User.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'reporting_name' => v.name
      }
    end
    resp
end

def getteam
  resp = []
    @value = TeamMaster.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'team_name' => v.team_name
      }
    end
    resp
end

def gettech
  resp = []
    @value = TechnologyMaster.all.order(:id)
    @value.each do |v|      
      resp << {
        'id' => v.id,
        'technology_name' => v.technology
      }
    end
    resp
end

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
