class UserPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def show?
    user.admin? || (user == record)
  end
  
  def update?
    user == record
  end

  def index?
    user.admin?
  end
end
