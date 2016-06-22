class Api::V1::PercentagesController < ApplicationController
	def index  
      @percentages = Percentage.all
          render json: @percentages
    
	end
end
