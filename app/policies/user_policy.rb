class UserPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def show?
    user.type=="Admin" || (user == record)
  end
  
  def update?
    user == record
  end
end
