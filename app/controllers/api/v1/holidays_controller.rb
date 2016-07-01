class Api::V1::HolidaysController < ApplicationController

before_action :authenticate_user!
before_action :set_holiday, only: [:show, :edit, :update]

def index

    @holidays = Holiday.all.order(:created_at => 'desc')
   resp=[]
     @holidays.each do |h| 
      resp << {
        'id' => h.id,
        'date' => h.date,
        }
      end

    #pagination(Holiday,@search)
    
    response = {
     # 'no_of_records' => @no_of_records.size,
      #'no_of_pages' => @no_pages,
      #'next' => @next,
      #'prev' => @prev,
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
      	render json: { valid: true, msg:"#{@holiday.date} created successfully."}  
      #index
    else
      render json: { valid: false, error: @holiday.errors }, status: 404
    end    
  end

 def update   

    if @holiday.update(holiday_params)  	      
       render json:{ valid: true, msg:"#{@holiday.date} updated successfully."}
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

      raw_parameters = { :date => "#{params[:date]}"}
      parameters = ActionController::Parameters.new(raw_parameters)
      parameters.permit(:date)
    
    end

end