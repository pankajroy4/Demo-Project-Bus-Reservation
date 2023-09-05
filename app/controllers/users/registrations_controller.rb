
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def after_sign_up_path_for(resource)
    user_path(resource) # Redirect to the user's profile
  end
  def after_update_path_for(resource)
    unless resource.type=="Admin"
      user_path(resource) 
    else
      admin_show_path(current_user&.id)
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:email,:password,:password_confirmation])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name,:email,:password,:password_confirmation])
  end

end
