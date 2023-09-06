class BusPolicy < ApplicationPolicy
  class Scope < Scope
    
  end

  def update?
    user.bus_owner? && (user.id == record.id)
  end

  def view?
    user.bus_owner? && (user.id == record.bus_owner_id)
  end

  def edit?
    update?
  end

  def destroy?
    user.bus_owner? && user.id == record.id
  end

  def reservations_list?
    user.bus_owner? && record.approved? && record.approved?
  end
  
  def get_list?
    user.bus_owner? && (record.bus_owner_id == user.id) 
  end

  def index?
    user.admin? || user.bus_owner?
  end
end

