class Api::V1::ActivityMastersController < ApplicationController

before_action :authenticate_user!

 def index  
   @activities = ActivityMaster.all
   render json: @activities     
 end

end
