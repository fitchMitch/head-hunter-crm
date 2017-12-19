class CompanyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.all
      end
    end
  end

  def index?
    true
  end

  def update?
    true
  end

  def create?
    true
  end

  def destroy?
    false
  end

end
