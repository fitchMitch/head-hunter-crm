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
    me_or_admin
  end

  def update?
    me_or_admin
  end

  def create?
    @user.admin?
  end

  def destroy?
    @user.admin?
  end
  private
    def me_or_admin
      user.id == record.id || (user.id != record.id && user.admin?)
    end

end
