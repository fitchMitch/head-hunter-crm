class MissionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        # scope.all
        scope.mine(current_user.id)
      end
    end
  end

  def index?
    true
  end

  def update?
    owner_or_admin?
  end

  def create?
    true
  end

  def show?
    owner_or_admin?
  end

  def destroy?
    owner_or_admin?
  end


end
