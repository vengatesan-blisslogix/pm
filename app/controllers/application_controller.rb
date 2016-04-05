class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

# protect_from_forgery with: :exception

 #protect_from_forgery with: :null_session

 $PER_PAGE = 3 #per page records
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
      :role_master_id,
      :name,     
      :password,
      :team_id,
      :prior_experience,
      :doj,
      :dob,
      :avatar,
      :last_name,
      :created_by_user,
      :reporting_to,
      :nickname,
      :active
    ]
  end

  def current_user
    if params[:user_id]
    current_user = User.find_by_id(params[:user_id])
    else
    render json: { valid: false, error: 'unauthorized user!!!' }, status: 404
    end
  end
  
def pagination(model)
@no_of_records = model.all
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
end
if @prev == nil
@prev = false
end
if @next == nil
@next = false
end



end
