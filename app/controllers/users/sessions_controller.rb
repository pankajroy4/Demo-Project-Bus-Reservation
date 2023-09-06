class Users::SessionsController < Devise::SessionsController
  
  def after_sign_in_path_for(resource)
    unless resource.admin?
      user_path(resource) 
    else
      admin_show_path(current_user&.id)
    end
  end
end



