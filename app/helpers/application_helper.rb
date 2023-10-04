module ApplicationHelper
  
  def current_user_admin?
      current_user&.admin?
  end

  def signed_in?
    user_signed_in? || bus_owner_signed_in?   
  end

  def current_user?(user)
    (( current_user&.id == user&.id ) || ( current_bus_owner&.id == user&.id ))
  end
end
