class Api::V1::ActivityMastersController < ApplicationController

before_action :authenticate_user!
before_action :set_activity_params, only: [:show, :edit, :update]

 def index  

    #search
        if params[:search]!=nil and params[:search]!=""
          @search ="id = #{params[:search]}"
        else
          @search =""
        end
        #search

  if params[:page]
      @activities = ActivityMaster.where("#{@search}").page(params[:page]).order(:id)
  else
      @activities = ActivityMaster.where("#{@search}").limit(20).order(:id)
  end
   resp=[]
     @activities.each do |a| 

      #if a.is_page == "yes"
      resp << {
        'id' => a.id,
        'activity_name' => a.activity_Name,
        'status' => a.active,
        'activity_description' => a.activity_description,
        'is_page' => a.is_page
      }
      #end
    end  
#@search=""
    pagination(ActivityMaster,@search)
    get_all_activity
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'activity_list' => @activity_resp,
      'resp' => resp
      

    }  
    render json: response       
 end

def show  
   render json: @activity
end

def create
    @activity = ActivityMaster.new(activity_params)
    if @activity.save
      @activity.active = "active"
        if params[:is_page]=="yes"
        @activity.icon="fa fa-fw fa-tachometer"
        end
       @activity.save

        RoleActivityMapping.create(role_master_id: 1, activity_master_id: 1, access_value: 1, user_id: 1, active: 1)

      render json: { valid: true, msg:"#{@activity.activity_Name} created successfully."}
     else
        render json: { valid: false, error: @activity.errors }, status: 404
     end    
end

 def update   

    if @activity.update(activity_params)        
       render json: { valid: true, msg:"#{@activity.activity_Name} updated successfully."}
     else
        render json: { valid: false, error: @activity.errors }, status: 404
     end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_activity_params
      @activity = ActivityMaster.find_by_id(params[:id])
      if @activity
      else
        render json: { valid: false}, status: 404
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params           
    
      raw_parameters = { 
       :activity_Name => "#{params[:activity_name]}",
       :active => "#{params[:active]}",
       :activity_description => "#{params[:activity_description]}",
       :is_page => "#{params[:is_page]}"
   }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit( :activity_Name, :active, :activity_description, :is_page)
    
    end

end
