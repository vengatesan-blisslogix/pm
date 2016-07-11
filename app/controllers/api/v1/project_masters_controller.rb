class Api::V1::ProjectMastersController < ApplicationController

after_action :set_avatar, only: [:update, :create]

before_action :authenticate_user!
before_action :set_project_master, only: [:show, :edit, :update]



def index  
  #search
  if params[:client_id]!=nil and params[:client_id]!="" and params[:client_id]!= "undefined"
    @search_client ="client_id = #{params[:client_id]}"
  else
    @search_client =""
  end
  puts "-----#{params[:project_id]}-------"
  if params[:project_id]!=nil and params[:project_id]!="" and params[:project_id]!= "undefined"
    @search_word ="id = #{params[:project_id]}"
  else
    @search_word =""
  end
  if @search_client != "" and @search_word != ""
    @search = "#{@search_client} and #{@search_word}"
  elsif @search_client != ""
    @search = "#{@search_client}"
  elsif @search_word !=""
    @search = "#{@search_word}"
  else
    @search = ""
  end

@find_user = User.find_by_id(params[:user_id])
  if @find_user and @find_user
    
  end
  #search

  @project_masters = ProjectMaster.where("#{@search}").page(params[:page]).order(:created_at => 'desc')
@project_users = ProjectUser.where("#{@search}").order(:created_at => 'desc')
 if params[:check_pu] and params[:check_pu].to_i == 1 and  @project_users!=nil  and  @project_users.size!=0
    @exist_pu = true
  else
    @exist_pu = false
  end


  
  resp=[]
  @project_masters.each do |p| 
      @pro_type = ProjectType.find_by_id(p.project_type_id)
      if @pro_type!=nil && @pro_type!=""
      @pro_type =@pro_type.project_name
      else
      @pro_type=""
      end
      @domain = ProjectDomain.find_by_id(p.domain_id)
      if @domain!=nil && @domain!=""
      @domain =@domain.domain_name
      else
      @domain=""
      end
      @client = Client.find_by_id(p.client_id)
      if @client!=nil && @client!=""
      @client =@client.client_name
      else
      @client=""
      end    
      @pro_status = ProjectStatusMaster.find_by_id(p.project_status_master_id)
      if @pro_status!=nil && @pro_status!=""
        @pro_status =@pro_status.status
      else
        @pro_status=""
      end
         puts "#{p.avatar}"



      resp << {
        'id' => p.id,
        'project_type' => @pro_type,
        'project_name' => p.project_name,
        'domain_name' => @domain,
        'client_name' => @client,
        'billable' => p.billable,
        'assign_start_date' => p.start_date,
        'end_date' => p.end_date,
        'project_status' => @pro_status,
        'tag_keywords' => p.tag_keywords,
        'kickstart_date' => p.kickstart_date,        
        'status' => p.active,
        'avatar' => p.avatar
      }
  end

  pagination(ProjectMaster,@search)        
  get_all_projects
  get_all_clients
  response = {
  'no_of_records' => @no_of_records.size,
  'no_of_pages' => @no_pages,
  'next' => @next,
  'prev' => @prev,
  'clients_list' => @client_resp,
  'projects' => resp,
  'check_pu' => @exist_pu

  }
  render json: response    
end

def show	
   render json: @project_master
end

def create

    @project_master = ProjectMaster.new(project_master_params)
    if @project_master.save
        @project_master.active = "active"
        @project_master.save
    	render json: { valid: true, msg:"#{@project_master.project_name} created successfully."}
     else
        render json: { valid: false, error: @project_master.errors }, status: 404
     end
    
end

 def update   

    if @project_master.update(project_master_params)  	      
       render json: { valid: true, msg:"#{@project_master.project_name} updated successfully."}
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

  
    def set_avatar
      if params[:avatar]!=nil and params[:avatar]!=""
    @project_master.avatar = params[:avatar]
    @project_master.save
  end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_master_params           
    
      raw_parameters = { 
       :project_type_id => "#{params[:project_type_id]}",
       :billable => "#{params[:billable]}",
       :project_name => "#{params[:project_name]}",
       :description => "#{params[:description]}",
       :project_image => "#{params[:project_image]}",
       :domain_id => "#{params[:domain_id]}",
       :client_id => "#{params[:client_id]}",
       :created_by_user_id => "#{params[:created_by_user_id]}",
       :start_date => "#{params[:start_date]}",
       :end_date => "#{params[:end_date]}",
       :project_status_master_id => "#{params[:project_status_master_id]}",
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
      parameters.permit(:project_type_id, :billable, :project_name, :description, :project_image, :domain_id, :client_id, :created_by_user_id, :start_date, :end_date, :project_status_master_id, :website, :facebook_page, :twitter_page, :star_rating, :active, :tag_keywords, :flag_id, :approved, :approved_by_user_id, :approved_date_time, :assigned_to_user_id, :kickstart_date)
    
    end
end
