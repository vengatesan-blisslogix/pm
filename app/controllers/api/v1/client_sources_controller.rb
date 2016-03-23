class Api::V1::ClientSourcesController < ApplicationController
before_action :authenticate_user!
before_action :set_client_source, only: [:show, :edit, :update]



 def index
  if params[:page] && params[:per]
    @client_sources = ClientSource.page(params[:page]).per(params[:per])
  else
    @client_sources = ClientSource.limit(10)
  end
     render json: @client_sources 
    
 end

def show	
   render json: @client_source
end

def create

    @client_source = ClientSource.new(client_source_params)
    if @client_source.save
    	index
     else
        render json: { valid: false, error: @client_source.errors }, status: 404
     end
    
end

 def update   

    if @client_source.update(client_source_params)  	      
       render json: @client_source
     else
        render json: { valid: false, error: @client_source.errors }, status: 404
     end
  end
private

    # Use callbacks to share common setup or constraints between actions.
    def set_client_source
      @client_source = ClientSource.find_by_id(params[:id])
      if @client_source
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def client_source_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :source_name => "#{params[:source_name]}", :description => "#{params[:description]}", :active => "#{params[:active]}", :user_id => "#{params[:user_id]}" }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:source_name, :description, :active, :user_id)
    
    end
end
