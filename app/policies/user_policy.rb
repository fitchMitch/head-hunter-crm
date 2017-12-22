class UserPolicy < ApplicationPolicy

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

  def show?
    owner_or_admin?
  end

  def update?
    user.id == record.id || (user.id != record.id && user.admin?)
  end

  def create?
    @user.admin?
  end

  def destroy?
    user.admin? && record.id !=user.id
  end

end
