class Api::V1::CompaniesController < ApplicationController


	  before_action :authenticate_user!
before_action :set_company, only: [:show, :edit, :update]



 def index
  if params[:page] && params[:per]
    @companies = Company.page(params[:page]).per(params[:per])
  else
    @companies = Company.limit(20)
  end
     render json: @companies 
    
 end

def show  
   render json: @company
end

def create
     @company = Company.new(company_params)
     #@company.company_name = params[:company_name]   

     if @company.save
      render json: @company, status: 201
     else
       render json: @company.errors, status: 400
     end
   end

   def update
      if @company.update(company_params)             
      render json: @company
     else
       render json: { valid: false, error: @company.errors }, status: 404
     end
   end

  private
  # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find_by_id(params[:id])
      if @company
      else
        render json: { valid: false}, status: 404
      end
    end
    def company_params
      raw_parameters = { :company_name => "#{params[:company_name]}", :display_name => "#{params[:display_name]}", :web_address => "#{params[:web_address]}", :first_address => "#{params[:first_address]}", :second_address => "#{params[:second_address]}", :city => "#{params[:city]}", :state => "#{params[:state]}", :country => "#{params[:country]}", :zip_code => "#{params[:zip_code]}", :region => "#{params[:region]}", :email => "#{params[:email]}", :mobile => "#{params[:mobile]}", :phone1 => "#{params[:phone1]}", :phone2 => "#{params[:phone2]}", :fax => "#{params[:fax]}", :skype => "#{params[:skype]}", :star_rating => "#{params[:star_rating]}", :active => "#{params[:active]}", :comments => "#{params[:comments]}", :company_logo => "#{params[:company_logo
      ]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:company_name, :display_name, :web_address, :first_address, :second_address, :city, :state, :country, :zip_code, :region, :email, :mobile, :phone1, :phone2, :fax, :skype, :star_rating, :active, :comments, :company_logo)
    end


end

