class BusOwners::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def new 
    @type = "bus_owner" #needed in views to determine user_type
    super
  end
 
  def after_sign_up_path_for(resource)
    bus_owner_path(resource)
  end
  
  def after_update_path_for(resource)
    bus_owner_path(resource) 
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :registration_no, :user_type ])
    params[:bus_owner][:user_type] = 'bus_owner'
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :registration_no])
  end
end
