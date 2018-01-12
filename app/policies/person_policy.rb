class PersonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    true
  end

  def index?
    true
  end

  def update?
    owner_or_admin?
  end

  def edit?
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
