class Api::V1::ProjectDomainsController < ApplicationController

before_action :authenticate_user!
before_action :set_domain, only: [:show, :edit, :update]

def index
      #search
        if params[:search]!=nil and params[:search]!=""
          @search ="id = #{params[:search]}"
        else
          @search =""
        end
        #search


    @project_domains = ProjectDomain.where("#{@search}").page(params[:page]).order(:created_at => 'desc')

   resp=[]
     @project_domains.each do |pd| 

      if pd.active.to_i==1
        @status = "active"
      else
        @status = "inactive"
      end

      resp << {
        'id' => pd.id,
        'domain_name' => pd.domain_name,
        'active' => @status
      }
      end

    pagination(ProjectDomain,@search)
    get_all_domain

    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'domain_list' => @domain_resp,
      'domain_resp' => resp

    }
  render json: response 
end

def show	
     resp=[]

      if @project_domain.active.to_i==1
        @status = "active"
      else
        @status = "inactive"
      end

      resp << {
        'id' => @project_domain.id,
        'domain_name' => @project_domain.domain_name,
        'active' => @status
      }
   render json: resp
end

def create

    @project_domain = ProjectDomain.new(domain_params)
    if @project_domain.save
      @project_domain.active = 1
        @project_domain.save
    	render json: { valid: true, msg:"#{@project_domain.domain_name} created successfully."}  
      #index
    else
      render json: { valid: false, error: @project_domain.errors }, status: 404
    end    
  end

 def update   

    if @project_domain.update(domain_params)  
    if params[:active] == "active"
      @project_domain.active = 1
    else
      @project_domain.active = 0
    end
    @project_domain.save
       render json:{ valid: true, msg:"#{@project_domain.domain_name} updated successfully."}
     else
        render json: { valid: false, error: @project_domain.errors }, status: 404
     end
  end

private

    # Use callbacks to share common setup or constraints between actions.
    def set_domain
      @project_domain = ProjectDomain.find_by_id(params[:id])
      if @project_domain
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def domain_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :domain_name => "#{params[:domain_name]}", :active => "#{params[:active]}", :user_id => "#{params[:user_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:domain_name, :active, :user_id)    
    end
end
