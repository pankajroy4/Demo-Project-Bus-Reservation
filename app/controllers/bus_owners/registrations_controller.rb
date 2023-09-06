class BusOwners::RegistrationsController < Users::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def after_sign_up_path_for(resource)
    bus_owner_path(resource)
  end
  
  def after_update_path_for(resource)
    bus_owner_path(resource) 
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :registration_no,:user_type])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :registration_no])
  end
end
