class Api::V1::ProjectMastersController < ApplicationController

	#before_action :authenticate_user!
before_action :set_project_master, only: [:show, :edit, :update]



 def index
  if params[:page] && params[:per]
    @project_masters = ProjectMaster.page(params[:page]).per(params[:per])
  else
    @project_masters = ProjectMaster.limit(10)
  end
     render json: @project_masters 
    
 end

def show	
   render json: @project_master
end

def create

    @project_master = ProjectMaster.new(project_master_params)
    if @project_master.save
    	index
     else
        render json: { valid: false, error: @project_master.errors }, status: 404
     end
    
end

 def update   

    if @project_master.update(project_master_params)  	      
       render json: @project_master
     else
        render json: { valid: false, error: @project_master.errors }, status: 404
     end
  end
private

    # Use callbacks to share common setup or constraints between actions.
    def set_project_master
      @project_master = ProjectMaster.find_by_id(params[:id])
      if @project_master
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def project_master_params           
    
      raw_parameters = { 
       :billable => "#{params[:billable]}",
       :project_name => "#{params[:project_name]}",
       :description => "#{params[:description]}",
       :project_image => "#{params[:project_image]}",
       :domain_id => "#{params[:domain_id]}",
       :client_id => "#{params[:client_id]}",
       :created_by_user_id => "#{params[:created_by_user_id]}",
       :start_date => "#{params[:start_date]}",
       :end_date => "#{params[:end_date]}",
       :project_status_id => "#{params[:project_status_id]}",
       :website => "#{params[:website]}",
       :facebook_page => "#{params[:facebook_page]}",
       :twitter_page => "#{params[:twitter_page]}",
       :star_rating => "#{params[:star_rating]}",
       :active => "#{params[:active]}",
       :tag_keywords => "#{params[:tag_keywords]}",
       :flag_id => "#{params[:flag_id]}",
       :approved => "#{params[:approved]}",
       :approved_by_user_id => "#{params[:approved_by_user_id]}",
       :approved_date_time => "#{params[:approved_date_time]}",
       :assigned_to_user_id => "#{params[:assigned_to_user_id]}",
       :kickstart_date => "#{params[:kickstart_date]}"     

   }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:billable, :project_name, :description, :project_image, :domain_id, :client_id, :created_by_user_id, :start_date, :end_date, :project_status_id, :website, :facebook_page, :twitter_page, :star_rating, :active, :tag_keywords, :flag_id, :approved, :approved_by_user_id, :approved_date_time, :assigned_to_user_id, :kickstart_date)
    
    end
end
