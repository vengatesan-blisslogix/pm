class Api::V1::UsersController < ApplicationController


before_action :authenticate_user!
before_action :set_user, only: [:show, :edit, :update]



 def index

  #search
      if params[:role_id]!=nil and params[:role_id]!=""and params[:role_id]!= "undefined"
        @search_role ="role_master_id = #{params[:role_id]}"
      else
        @search_role =""
      end
      if params[:email]!=nil and params[:email]!="" and params[:project_id]!= "undefined"
        @search_email ="email = '#{params[:email]}'"
      else
        @search_email =""
      end


      if @search_role != "" and @search_email != ""
        @search = "#{@search_role} and #{@search_email}"
      elsif @search_role != ""
        @search = "#{@search_role}"
      elsif @search_email !=""
        @search = "#{@search_email}"
      else
        @search = ""
      end

      @find_user = User.find_by_id(params[:user_id])
      if @find_user and @find_user
        
      end
  #search

  puts "--#role---#{@search_role}------"
  puts "--#email---#{@search_email}------"
  puts "--#search---#{@search}------"

    @users = User.where("#{@search}").page(params[:page]).order(:id)
   
    resp=[]
    resp_email = []
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

        if u.active ==1
        @status="active"
        else
        @status="inactive"
        end
resp_email << { 'email' => u.email }    
 
        resp << {
          'id' => u.id,
          'first_name' => u.name,
          'last_name' => u.last_name,
          'email' => u.email,
          'avatar' =>  u.avatar,
          'role' =>@role,
          'reporting_to' =>@reporting_to,
          'project_assigned' =>"",
          'branch' =>@branch,
          'status' =>@status

        }
    end
      
    pagination(User,@search)
    
    @roles = RoleMaster.all.order(:id)
    role_resp=[]
    @roles.each do |r| 
       role_resp << {
      'id' => r.id,
      'role_name' => r.role_name      
    }
    end

     @teams = TeamMaster.all.order(:id)
    team_resp=[]
    @teams.each do |t| 
       team_resp << {
      'id' => t.id,
      'team_name' => t.team_name      
    }
    end

    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'roles' => role_resp,
      'emails'=> resp_email,
      'teams' => team_resp,
      'users' => resp
    }

    render json: response
    
 end

def show  
   render json: @user
end

 def update   
    if @user.update(user_params)        
       render json: { valid: true, msg:"#{@user.name} updated successfully."}
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
     raw_parameters = { :mobile_no => "#{params[:mobile_no]}", :office_phone => "#{params[:office_phone]}", :home_phone => "#{params[:home_phone]}", :profile_photo => "#{params[:profile_photo]}",:active => "#{params[:active]}", :branch_id => "#{params[:branch_id]}", :company_id => "#{params[:company_id]}", :role_master_id => "#{params[:role_master_id]}", :name => "#{params[:name]}", :password => "#{params[:password]}", :team_id => "#{params[:team_id]}", :prior_experience => "#{params[:prior_experience]}", :doj => "#{params[:doj]}", :dob => "#{params[:dob]}", :avatar => "#{params[:avatar]}", :last_name => "#{params[:last_name]}", :created_by_user => "#{params[:created_by_user]}", :reporting_to => "#{params[:reporting_to]}" }
     parameters = ActionController::Parameters.new(raw_parameters)
     parameters.permit(:mobile_no,
     :office_phone,
     :home_phone,
     :profile_photo,
     :active,
     :branch_id,
     :company_id,
     :role_master_id,
     :name,     
     :password,
     :team_id,
     :prior_experience,
     :doj,
     :dob,
     :avatar,
     :last_name,
     :created_by_user,
     :reporting_to)
   end


end
