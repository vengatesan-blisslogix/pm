class Api::V1::UsersController < ApplicationController

before_action :authenticate_user!
before_action :set_user, only: [:show]

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

    @users = User.where("#{@search}").page(params[:page]).order(:created_at => 'desc')
   
    resp=[]
    resp_email = []
    @users.each do |u| 
        @role = RoleMaster.find_by_id(u.role_master_id)
        if @role!=nil and @role!=""
        @role = @role.role_name
        else
        @role =""
        end

        #@reporting_to = User.find_by_name(u.reporting_to)
        #if @reporting_to!=nil and @reporting_to!=""
        #@reporting_to = @reporting_to.name
        #else
        #@reporting_to =""
        #end
        @reporting_to = u.reporting_to

        @branch = Branch.find_by_id(u.branch_id)
        if @branch!=nil and @branch!=""
        @branch = @branch.name
        else
        @branch =""
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
          'status' =>u.active,
          'employee_id' => u.employee_no

        }
    end
      
    pagination(User,@search)
    
    @roles = RoleMaster.all.order(:role_name)
    role_resp=[]
    @roles.each do |r| 
       role_resp << {
      'id' => r.id,
      'role_name' => r.role_name      
    }
    end

     @teams = TeamMaster.all.order(:team_name)
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

def create

    @user = User.new(user_params)
    if @user.save
      render json: { valid: true, msg:"#{@user.name} created successfully."}  
      #index
    else
      render json: { valid: false, error: @user.errors }, status: 404
    end    
  end

def show
  @tech_name = []  
  @user_tech = UserTechnology.where("user_id = #{@user.id}")  
  @user_tech.each do |ut|
    @tech_first = TechnologyMaster.find_by_id(ut.technology_master_id)
    @tech_name << {
      'id' => ut.technology_master_id,
      'technology_name' => @tech_first.technology      
    }
  end
  #puts "-----------#{@user.reporting_to.split("(")[0].strip}--------------"
  response = {
        'name' => @user.name,
        'last_name' => @user.last_name,
        'nickname' => @user.nickname,
        'email' => @user.email,
        'mobile_no' => @user.mobile_no,
        'office_phone' => @user.office_phone,
        'home_phone' => @user.home_phone,
        'profile_photo' => @user.profile_photo,
        'avatar_file_name' => @user.avatar,
        'active' => @user.active,
        'prior_experience' => @user.prior_experience,
        'doj' => @user.doj,
        'dob' => @user.dob,
        'team_id' =>@user.team_id,
        'created_by_user' => @user.created_by_user,
        'reporting_to' => @user.reporting_to,
        'branch_id' => @user.branch_id,
        'company_id' => @user.company_id,
        'role_master_id' => @user.role_master_id,     
        'employee_no' => @user.employee_no,
        'user_technology' => @tech_name
    }
   render json: response
end

 def update
  set_user
    begin
      @user.name = params[:name]
      @user.last_name = params[:last_name]
      @user.nickname = params[:nickname]
      @user.email = params[:email]
      @user.mobile_no = params[:mobile_no]
      @user.office_phone = params[:office_phone]
      @user.home_phone = params[:home_phone]
      @user.avatar = params[:avatar]
      @user.active = params[:active]
      @user.doj = params[:doj]
      @user.dob = params[:dob]
      @user.prior_experience = params[:prior_experience]
      @user.team_id = params[:team_id]
      @user.created_by_user = params[:created_by_user]
      @user.reporting_to = params[:reporting_to]
      @user.branch_id = params[:branch_id]
      @user.company_id = params[:company_id]
      @user.role_master_id = params[:role_master_id]      
      @user.employee_no = params[:employee_no]
      #@user.technology_id = params[:technology_id]

      @user.save
add_user_tech(@user.id, params[:technology_id])
       render json: { valid: true, msg:"#{@user.name} updated successfully."}
     rescue
      render json: { valid: false, error: "Invalid parameters" }, status: 404
     end
  end

private

def add_user_tech(user_id, technology_master_id)
  if technology_master_id != nil and technology_master_id != ""
    @user_technology = UserTechnology.destroy_all(:user_id => user_id)
    technology_master_id.split(",").each do |tm|
       @ut = UserTechnology.new
       @ut.technology_master_id = tm
       @ut.user_id = user_id
       @ut.save
    end
  end
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
     raw_parameters = { :mobile_no => "#{params[:mobile_no]}", :office_phone => "#{params[:office_phone]}", :home_phone => "#{params[:home_phone]}", :profile_photo => "#{params[:profile_photo]}",:active => "#{params[:active]}", :branch_id => "#{params[:branch_id]}", :company_id => "#{params[:company_id]}", :role_master_id => "#{params[:role_master_id]}", :name => "#{params[:name]}", :email => "#{params[:email]}", :password => "#{params[:password]}",:team_id => "#{params[:team_id]}", :prior_experience => "#{params[:prior_experience]}", :doj => "#{params[:doj]}", :dob => "#{params[:dob]}", :avatar => "#{params[:avatar]}", :last_name => "#{params[:last_name]}", :created_by_user => "#{params[:created_by_user]}", :reporting_to => "#{params[:reporting_to]}", :employee_no => "#{params[:employee_no]}" }

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
     :email,
     :team_id,
     :prior_experience,
     :doj,
     :dob,
     :avatar,
     :last_name,
     :created_by_user,
     :reporting_to,
     :employee_no)
   end


end
