class CheckinPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin_roles?
        scope.own_shop(user.managed_shops).exclude_system_created
      else
        scope.own_shop(user.shop_ids).exclude_system_created
      end
    end
  end
end
