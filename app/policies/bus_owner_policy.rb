class BusOwnerPolicy < ApplicationPolicy

  def show?
    user.admin? ||  ( user.bus_owner? &&  user.id == record&.id )
  end 
  
  def index?
    user.admin?
  end
end
