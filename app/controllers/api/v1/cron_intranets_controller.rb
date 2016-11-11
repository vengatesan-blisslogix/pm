class Api::V1::CronIntranetsController < ApplicationController

  def create
    @ci = CronIntranet.new(cron_intranet_params)
    if @user.save
      render json: { valid: true, msg:"#{@ci.emp_name} created successfully."}  
      #index
    else
      render json: { valid: false, error: @ci.errors }, status: 404
    end    
  end


private
def cron_intranet_params
     raw_parameters = { :emp_codes => "#{params[:emp_codes]}", 
     :emp_name => "#{params[:emp_name]}", 
     :emp_gender => "#{params[:emp_gender]}", 
     :emp_doj => "#{params[:emp_doj]}",
     :emp_status => "#{params[:emp_status]}", 
     :emp_reporting_to => "#{params[:emp_reporting_to]}", 
     :emp_department => "#{params[:emp_department]}", 
     :emp_location => "#{params[:emp_location]}",
     :emp_company => "#{params[:emp_company]}", 
     :emp_current_exp => "#{params[:emp_current_exp]}", 
     :emp_previous_exp => "#{params[:emp_previous_exp]}",
     :emp_total_exp => "#{params[:emp_total_exp]}", 
     :emp_left_org => "#{params[:emp_left_org]}", 
     :emp_dob => "#{params[:emp_dob]}", 
     :emp_dow => "#{params[:emp_dow]}", 
     :emp_blood_group => "#{params[:emp_blood_group]}", 
     :emp_phone => "#{params[:emp_phone]}", 
     :emp_mobile => "#{params[:emp_mobile]}",
     :emp_email => "#{params[:emp_email]}", 
     :emp_photo => "#{params[:emp_photo]}" }

     parameters = ActionController::Parameters.new(raw_parameters)
     parameters.permit( :emp_codes,
		 :emp_name,
		 :emp_gender,
		 :emp_doj,
		 :emp_status,
		 :emp_reporting_to,
		 :emp_department,
		 :emp_location,
		 :emp_company,
		 :emp_current_exp,
		 :emp_previous_exp,
		 :emp_total_exp,
		 :emp_left_org,
		 :emp_dob,
		 :emp_dow,
		 :emp_blood_group,
		 :emp_phone,
		 :emp_mobile,
		 :emp_email,
		 :emp_photo
		 )
   end

end
