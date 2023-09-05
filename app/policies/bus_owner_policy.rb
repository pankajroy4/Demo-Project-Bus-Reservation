class BusOwnerPolicy < ApplicationPolicy

  # class Scope < Scope
  # end

  def show?
    user&.type =="Admin" || user == record
  end 

end
