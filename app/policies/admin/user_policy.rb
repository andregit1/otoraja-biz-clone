class Admin::UserPolicy < ApplicationPolicy

  def access_admin?
    user.shop_admin_roles?
  end

  def index?
    user.owner?
  end

  def new?
    user.owner?
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
          scope.own_shop(user.shop_ids).where(role: ['staff', 'shop_manager'])
        else
          scope.own_shop(user.shop_ids).where(role: ['staff'])
      end
    end
  end
end
