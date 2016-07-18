class Api::V1::ProjectPaymentsController < ApplicationController

before_action :authenticate_user!
before_action :set_payment, only: [:show, :edit, :update]

def index
	#search
        if params[:search]!=nil and params[:search]!=""
          @search ="id = #{params[:search]}"
        else
          @search =""
        end
    #search

    @project_payments = ProjectPayment.where("#{@search}").page(params[:page]).order(:created_at => 'desc')
    resp=[]
     @project_payments.each do |pp| 
      resp << {
        'id' => pp.id,
        'name' => pp.name,
        'active' => pp.active,
        'description' => pp.description
      }
      end

    pagination(ProjectPayment,@search)
    get_all_payment
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'payment_list' => @payment_resp,
      'payment_resp' => resp

    }
  render json: response
 
end

def show	
   render json: @project_payment
end

def create

    @project_payment = ProjectPayment.new(payment_params)
    if @project_payment.save
            @project_payment.active = "active"
        @project_payment.save
    	render json: { valid: true, msg:"#{@project_payment.name} created successfully."}  
      #index
    else
      render json: { valid: false, error: @project_payment.errors }, status: 404
    end    
  end

 def update   

    if @project_payment.update(payment_params)  	      
       render json: { valid: true, msg:"#{@project_payment.name} updated successfully."}
    else
        render json: { valid: false, error: @project_payment.errors }, status: 404
    end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @project_payment = ProjectPayment.find_by_id(params[:id])
      if @project_payment
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :name => "#{params[:name]}", :active => "#{params[:active]}", :user_id => "#{params[:user_id]}", :description => "#{params[:description]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:name, :active, :description, :user_id)
    
    end

end
