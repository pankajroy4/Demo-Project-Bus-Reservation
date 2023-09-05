class BusPolicy < ApplicationPolicy
  # class Scope < Scope
  #   def resolve
  #     scope.where(bus_owner_id: user.id)
  #   end
  # end

  def update?
    user&.type=="BusOwner" && user&.id == record.bus_owner_id
  end

  def edit?
    update?
  end

  def destroy?
    user&.type=="BusOwner" && user&.id == record.bus_owner_id
  end

  def reservations_list?
    user&.type=="BusOwner" && user&.id == record.bus_owner_id
  end
  
  def get_list?
    user&.type=="BusOwner" && user&.id == record.bus_owner_id
  end
end

