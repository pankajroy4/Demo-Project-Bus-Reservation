module ApplicationHelper
  def current_user_admin?
      current_user&.type=="Admin"
  end

  def signed_in?
    user_signed_in? || bus_owner_signed_in?   
  end

  def current_user?(user)
    (( current_user==user) || (current_bus_owner == user))
  end

end
