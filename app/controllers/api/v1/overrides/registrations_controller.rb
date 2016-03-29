class Api::V1::Overrides::RegistrationsController < DeviseTokenAuth::RegistrationsController
after_action :set, only: :create, if: :provider_present?


def provider_present?
    params[:provider]
  end
  def set_provider
    @resource.update_attributes(provider: params[:provider])
    @resource.uid=params[:uid] if params[:uid]
    @resource.save
  end

end
