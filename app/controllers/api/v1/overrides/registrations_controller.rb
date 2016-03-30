class Api::V1::Overrides::RegistrationsController < DeviseTokenAuth::RegistrationsController
after_action :tech_mapping, only: [:update, :create], if: :tech_present?
before_action :authenticate_user!
  private

  def tech_present?
    params[:technology_id]
  end

  def tech_mapping
  	if params[:technology_id]!="" && params[:technology_id]!=nil
     params[:technology_id] = params[:technology_id].gsub('"',"")
       
     UserTechnology.destroy_all(:user_id => @resource.id)
     @all_tech = TechnologyMaster.where("id IN (#{params[:technology_id]})")

        @all_tech.each do |t|
    	UserTechnology.create(technology_master_id: t.id, user_id: @resource.id)
        end
  	end 
  end


end
