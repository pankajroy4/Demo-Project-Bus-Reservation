class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def new 
    @type = "user" #needed in views to determine user_type
    super
  end

  def after_sign_up_path_for(resource)
    user_path(resource) 
  end
  
  def after_update_path_for(resource)
    unless resource.admin?
      user_path(resource) 
    else
      admin_show_path(current_user&.id)
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :user_type])
    params[:user][:user_type] = 'user'
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
