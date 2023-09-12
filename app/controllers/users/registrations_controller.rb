
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # def create
    # build_resource(sign_up_params)

    # if resource.save
    #   yield resource if block_given?
    #   if resource.active_for_authentication?
    #     set_flash_message! :notice, :signed_up
    #     sign_up(resource_name, resource)
    #     respond_with resource, location: after_sign_up_path_for(resource)
    #   else
    #     set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
    #     expire_data_after_sign_in!
    #     respond_with resource, location: after_inactive_sign_up_path_for(resource)
    #   end
    # else
    #   clean_up_passwords resource
    #   set_minimum_password_length
    #   respond_with resource
    # end
  # end

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
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
