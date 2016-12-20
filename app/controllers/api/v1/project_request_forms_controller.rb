class Api::V1::ProjectRequestFormsController < ApplicationController

after_action :set_signed_copy, only: [:update, :create]
after_action :set_mail_approval, only: [:update, :create]


before_action :authenticate_user!
before_action :set_project_form, only: [:show, :edit, :update]

def index
	#search
        if params[:search]!=nil and params[:search]!=""
          @search ="id = #{params[:search]}"
        else
          @search =""
        end
    #search

    @project_request_forms = ProjectRequestForm.where("#{@search}").page(params[:page]).order(:created_at => 'desc')
    resp=[]
     @project_request_forms.each do |pp| 
      resp << {
        'id' => pp.id,
        'name' => pp.project_name,
        'sow_no' => pp.sow_no,
        'project_manager' => pp.project_manager,
        'account_manager_name' => pp.account_manager_name
      }
      end

    pagination(ProjectRequestForm,@search)
    get_all_project_request_forms
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'request_form_list' => @request_form_resp,
      'request_form_resp' => resp

    }
  render json: response
 
end

def show	
   render json: @project_request_form
end

def create

    @project_request_form = ProjectRequestForm.new(project_request_params)
    if @project_request_form.save            
       render json: { valid: true, msg:"#{@project_request_form.project_name} created successfully."}  
      #index
    else
      render json: { valid: false, error: @project_request_form.errors }, status: 404
    end    
  end

 def update   

    if @project_request_form.update(project_request_params)  	      
       render json: { valid: true, msg:"#{@project_request_form.project_name} updated successfully."}
    else
        render json: { valid: false, error: @project_request_form.errors }, status: 404
    end
  end


private

    def set_signed_copy
      if params[:signed_copy]!=nil and params[:signed_copy]!=""
        @project_request_form.signed_copy = params[:signed_copy]
        @project_request_form.save
      end
    end

    def set_mail_approval
       if params[:mail_approval]!=nil and params[:mail_approval]!=""
        @project_request_form.mail_approval = params[:mail_approval]
        @project_request_form.save
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_project_form
      @project_request_form = ProjectRequestForm.find_by_id(params[:id])
      if @project_request_form
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def project_request_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :project_name => "#{params[:project_name]}", :project_manager => "#{params[:project_manager]}", :project_type_id => "#{params[:project_type_id]}", :billable => "#{params[:billable]}", :project_description => "#{params[:project_description]}", :project_domain_id => "#{params[:project_domain_id]}", :client_name => "#{params[:client_name]}", :kickstart_date => "#{params[:kickstart_date]}", :planned_start_date => "#{params[:planned_start_date]}", :planned_end_date => "#{params[:planned_end_date]}", :tag_keyword => "#{params[:tag_keyword]}", :project_status_master_id => "#{params[:project_status_master_id]}", :project_location_id => "#{params[:project_location_id]}", :sow_no => "#{params[:sow_no]}", :signoff_attachment => "#{params[:signoff_attachment]}", :account_manager_name => "#{params[:account_manager_name]}", :website_page => "#{params[:website_page]}", :facebook_page => "#{params[:facebook_page]}", :twitter_page => "#{params[:twitter_page]}", :business_unit_id => "#{params[:business_unit_id]}", :enagement_type_id => "#{params[:enagement_type_id]}", :payment_cylce => "#{params[:payment_cylce]}", :team_member_allocation => "#{params[:team_member_allocation]}", :signoff_date => "#{params[:signoff_date]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:project_name, 
      	:project_manager, 
      	:project_type_id,
      	:billable,
      	:project_description,
        :project_domain_id,
        :client_name,
        :kickstart_date,
        :planned_start_date,
        :planned_end_date,
        :tag_keyword,
        :project_status_master_id,
        :project_location_id,
        :sow_no,
        :signoff_attachment,
        :account_manager_name,
        :website_page,
        :facebook_page,
        :twitter_page,
        :business_unit_id,
        :enagement_type_id,
        :payment_cylce,
        :team_member_allocation,
        :signoff_date)    
    end
end
