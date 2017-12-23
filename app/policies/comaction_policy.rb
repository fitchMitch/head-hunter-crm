class ComactionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.mine(current_user.id)
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
    true
  end

  def destroy?
    owner_or_admin?
  end
end
