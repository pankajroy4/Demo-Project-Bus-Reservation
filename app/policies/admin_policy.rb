class AdminPolicy < ApplicationPolicy
  class Scope < Scope
    # def resolve
    # end
  end

  def show?
    user.admin? && user.id == record.id
  end

  def disapprove?
    user.admin?
  end
   
  def approve?
    user.admin?
  end
end
