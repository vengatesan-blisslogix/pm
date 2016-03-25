class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

# protect_from_forgery with: :exception

 #protect_from_forgery with: :null_session
 
 before_action :configure_permitted_parameters, if: :devise_controller?
  
  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [
      :mobile_no,
      :office_phone,
      :home_phone,
      :profile_photo,
      :active,
      :branch_id,
      :company_id,
      :role_master_id
    ]
  end

  def current_user
    if params[:user_id]
    current_user = User.find_by_id(params[:user_id])
    else
    render json: { valid: false, error: 'unauthorized user!!!' }, status: 404
    end
  end
  
end
