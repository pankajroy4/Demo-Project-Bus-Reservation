class BusOwners::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    bus_owner_path(resource)
  end
end
