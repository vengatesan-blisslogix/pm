class Api::V1::ClientsController < ApplicationController
before_action :authenticate_user!
before_action :set_client, only: [:show, :edit, :update]

 def index  
  get_all_clients
      #search
        if params[:client_id]!=nil and params[:client_id]!=""
          @search_client ="id = #{params[:client_id]}"
        else
          @search_client =""
        end
        if params[:search]!=nil and params[:search]!=""
          @search_word ="(client_name like '%#{params[:search]}%' or client_company_name like '%#{params[:search]}%' or  web_address like '%#{params[:search]}%' or client_email like '%#{params[:search]}%' or mobile like '%#{params[:search]}%' or skypke like '%#{params[:search]}%' or tag like '%#{params[:search]}%')"
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

if @search_all_pro==""
  @search = @search
else
    if @search!=""
    @search = @search + "and "+@client_find 
    else
    @search = @client_find 
    end
end



      #search

    @clients = Client.where("#{@search}").page(params[:page]).order(:created_at => 'desc')

    resp=[]
     @clients.each do |c| 
      
      #if c.active.to_i==1
      #  @status="active"
      #else
       # @status="inactive"
      #end


     
     @c_source=ClientSource.find_by_id(c.client_source_id)
       if @c_source!=nil && @c_source!=""
        @client_source=@c_source.source_name
      else
        @client_source=""
      end
      resp << {
        'id' => c.id,
        'client_name' => c.client_name,
        'client_company_name' => c.client_company_name,
        'client_source' => @client_source,
        'web_address' => c.web_address,
        'client_email' => c.client_email,
        'mobile' => c.mobile,        
        'skype' => c.skypke,
        'tag' => c.tag,
        'status' => c.active,

      }
      end
   
    pagination(Client,@search)
    get_all_clients
    
    response = {
      'no_of_records' => @no_of_records.size,
      'no_of_pages' => @no_pages,
      'next' => @next,
      'prev' => @prev,
      'clients_list' => @client_resp,      
      'roles' => resp
    }

    render json: response  
    
    
 end

def show	
   render json: @client
end

def create

    @client = Client.new(client_params)
    if @client.save
      @client.active = "active"
      @client.save
    	render json: { valid: true, msg:"#{@client.client_name} created successfully."}
     else
        render json: { valid: false, error: @client.errors }, status: 404
     end
    
end

 def update   

    if @client.update(client_params)  	      
       render json: { valid: true, msg:"#{@client.client_name} updated successfully."}
     else
        render json: { valid: false, error: @client.errors }, status: 404
     end
  end
private

    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find_by_id(params[:id])
      if @client
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      
      raw_parameters = { 
       :client_name => "#{params[:client_name]}",
       :web_address => "#{params[:web_address]}",
       :client_company_name => "#{params[:client_company_name]}",
       :first_address => "#{params[:first_address]}",
       :second_address => "#{params[:second_address]}",
       :city => "#{params[:city]}",
       :state => "#{params[:state]}",
       :country => "#{params[:country]}",
       :zip_code => "#{params[:zip_code]}",
       :region => "#{params[:region]}",
       :client_email => "#{params[:client_email]}",
       :mobile => "#{params[:mobile]}",
       :phone1 => "#{params[:phone1]}",
       :phone2 => "#{params[:phone2]}",
       :fax => "#{params[:fax]}",
       :skypke => "#{params[:skypke]}",
       :star_rating => "#{params[:star_rating]}",
       :active => "#{params[:active]}",
       :comments => "#{params[:comments]}",
       :tag => "#{params[:tag]}",
       :archived => "#{params[:archived]}",
       :client_source_id => "#{params[:client_source_id]}",  
       :user_id => "#{params[:user_id]}" 

   }
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:client_name, :web_address, :client_company_name, :first_address, :second_address, :city, :state, :country, :zip_code, :region, :client_email, :mobile, :phone1, :phone2, :fax, :skypke, :star_rating, :active, :comments, :tag, :archived, :client_source_id, :user_id)
    
    end
end
