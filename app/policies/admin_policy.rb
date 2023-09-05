class AdminPolicy < ApplicationPolicy
  class Scope < Scope
    # def resolve
    # end
  end

  def show?
    user&.type=="Admin" && user==record
  end

  def disapprove?
    user&.type=="Admin" 
  end
   
  def approve?
    user&.type=="Admin" 
  end

end
