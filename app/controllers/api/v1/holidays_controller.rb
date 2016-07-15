class Api::V1::HolidaysController < ApplicationController

before_action :authenticate_user!
before_action :set_holiday, only: [:show, :edit, :update]

def index
      #search
        if params[:search]!=nil and params[:search]!=""
          @search ="id = #{params[:search]}"
        else
          @search =""
        end
      #search  
if params[:view_all] and params[:view_all].to_i==1
  @per=""
else
  @per=20
end
    @holidays = Holiday.where("#{@search}").page(params[:page]).per(@per).order(:created_at => 'desc')
   resp=[]
     @holidays.each do |h| 
      resp << {
        'id' => h.id,
        'description' => h.description,
        'date' => h.date.strftime("%m/%d/%Y")
        }
      end

    

@no_of_records = Holiday.where("#{@search}").all
    @no_of_pages = @no_of_records.size.to_i.divmod($PER_PAGE.to_i)
        @no_pages = @no_of_pages[0].to_i
        if @no_of_pages[1].to_i!=0
        @no_pages = @no_pages+1
        end
        if params[:page]!=nil and params[:page]!="" and params[:page].to_i!=0
        current_page = params[:page].to_i
        else
        current_page = 1
        end

    if @no_pages.to_i > 1 && current_page == 1
      @prev = false
      @next = "page=#{current_page+1}"
    end
    if @no_pages.to_i > 1 && current_page == @no_pages.to_i
       @prev = "page=#{current_page-1}"
       @next = false
    end
    if @no_pages.to_i > 1 && current_page != 1 && current_page != @no_pages.to_i
      @prev = "page=#{current_page-1}"
      @next = "page=#{current_page+1}"
    end
   
    if @prev == nil
    @prev = false
    end
    if @next == nil
    @next = false
    end


    get_all_holiday

    response = {
     'no_of_records' => @no_of_records.size,
     'no_of_pages' => @no_pages,
     'next' => @next,
     'prev' => @prev,
     'holiday_list' => @holiday_resp,
     'holiday_resp' => resp

    }
  render json: response 
end

def show	
   render json: @holiday
end

def create

    @holiday = Holiday.new(holiday_params)
    if @holiday.save
      	render json: { valid: true, msg:"#{@holiday.date.strftime("%d/%m/%Y")} created successfully."}  
      #index
    else
      render json: { valid: false, error: @holiday.errors }, status: 404
    end    
  end

 def update   

    if @holiday.update(holiday_params)  	      
       render json:{ valid: true, msg:"#{@holiday.date.strftime("%d/%m/%Y")} updated successfully."}
     else
        render json: { valid: false, error: @holiday.errors }, status: 404
     end
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_holiday
      @holiday = Holiday.find_by_id(params[:id])
      if @holiday
      else
      	render json: { valid: false}, status: 404
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def holiday_params
      #params.require(:branch).permit(:name, :active, :user_id)

      raw_parameters = { :date => "#{params[:date]}", :description => "#{params[:description]}"}
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:date, :description)
    
    end

end
