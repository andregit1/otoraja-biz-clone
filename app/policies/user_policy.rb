class UserPolicy < ApplicationPolicy

  def index?
    user.admin_roles?
  end

  def new?
    !user.staff?
  end

  def show?
    true
  end

  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      case user.role
      when 'admin' then
        scope.all
      when 'owner' then
        scope.own_shop(user.shop_ids).where(role: ['owner', 'manager', 'staff', 'shop_manager'])
      when 'manager' then
        scope.own_shop(user.shop_ids).where(role: ['manager', 'staff', 'shop_manager'])
      when 'shop_manager' then
        scope.own_shop(user.shop_ids).where(role: ['manager', 'staff', 'shop_manager'])
      else
        scope.own_shop(user.shop_ids).where(role: ['staff'])
      end
    end
  end
end
