class Api::V1::RoleMastersController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update]
  before_action :authenticate_user!


 def index
  #search
        if params[:search]!=nil and params[:search]!=""
          @search ="id = #{params[:search]}"
        else
          @search =""
        end
        #search
  
    @roles = RoleMaster.where("#{@search}").page(params[:page]).order(:id)    

     resp=[]
     @roles.each do |r| 
      @no_of_act = RoleActivityMapping.where(:role_master_id => r.id)

      resp << {
        'id' => r.id,
        'role_name' => r.role_name,
        'no_of_activies' => @no_of_act.size,
        'description' => r.description,
        'status' => r.active
      }
      end
#   @search=""
    pagination(RoleMaster,@search)
    get_all_role
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'role_list' => @role_resp,
      'roles' => resp
    }

    render json: response
    
 end

def show	
  resp=[]
  
     resp << {
        'id' => @role.id,
        'role_name' => @role.role_name,
        'description' => @role.description,
        'status' => @role.active,
        'activity' => getaccess(@role.id)
      }
      render json: resp
end

def create

    @role = RoleMaster.new(role_master_params)
    if @role.save
          @role.active = "active"
        @role.save
      if params[:activity_id] && params[:activity_id]!=""
        params[:activity_id] = params[:activity_id].gsub('"',"")
    	@all_activity = ActivityMaster.where("id IN (#{params[:activity_id]})")
        @all_activity.each do |act|
    	RoleActivityMapping.create(role_master_id: @role.id, activity_master_id: act.id, access_value: 1, user_id: current_user.id)
        end
      end
        render json: { valid: true, msg:"#{@role.role_name} created successfully."}
     else
        render json: { valid: false, msg: @role.errors }, status: 404
     end
    
end

 def update   
 
    if @role.update(role_master_params)
      if params[:active] and params[:active]!= nil and params[:active]!= ""
      else
        @role.active = "active"
      end
      if params[:activity_id] && params[:activity_id]!=""
        params[:activity_id] = params[:activity_id].gsub('"',"")
    	@all_activity = ActivityMaster.where("id IN (#{params[:activity_id]})")
      RoleActivityMapping.destroy_all(:role_master_id => @role.id)
        @all_activity.each do |act|
    	RoleActivityMapping.create(role_master_id: @role.id, activity_master_id: act.id, access_value: 1, active: 1, user_id: current_user.id)
        end  
        end  

       render json: { valid: true, msg:"#{@role.role_name} updated successfully."}
     else
        render json: { valid: false, msg: @role.errors }, status: 404
     end
  end
private

    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = RoleMaster.find_by_id(params[:id])
      if @role
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def role_master_params
     # params.require(:role_master).permit(:role_name)
     raw_parameters = { :role_name => "#{params[:role_name]}", :active => "#{params[:active]}", :description=> "#{params[:description]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:role_name, :active, :description)
    end

    def getaccess(role_id)
    resp = []
    @access_value = ActivityMaster.all.page(params[:page])
    @access_value.each do |access|
      @activity = RoleActivityMapping.where("role_master_id=#{role_id} and activity_master_id=#{access.id}")
      if @activity!=nil and @activity.size!=0
        @selected = true
      else
        @selected = false
      end
      resp << {
        'id' => access.id,
        'action' => access.activity_Name,
        'selected' => @selected
      }
    end
    resp
    @search=""
    pagination(ActivityMaster,@search)
    
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'roles' => resp
    }
  end

end
