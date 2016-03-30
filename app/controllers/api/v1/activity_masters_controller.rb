class Api::V1::ActivityMastersController < ApplicationController

before_action :authenticate_user!

 def index  
   @activities = ActivityMaster.all.order(:id)

   resp=[]
     @activities.each do |a| 
      resp << {
        'id' => a.id,
        'activity_name' => a.activity_Name
        
      }
      end
    render json: resp 
       
 end

end
