class BusOwners::RegistrationsController < Users::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :authenticate_bus_owner!

  #  def create
  #  sign_in(resource)
  #    super
  #  end

  def after_sign_up_path_for(resource)
    bus_owner_path(resource) # Redirect to the user's profile
  end
  
  def after_update_path_for(resource)
    bus_owner_path(resource) # Redirect to the user's profile
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:email,:password,:password_confirmation,:registration_no,:type])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name,:email,:password,:password_confirmation,:registration_no])
  end
end
