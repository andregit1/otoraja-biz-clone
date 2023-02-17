class MaintenanceLogPolicy < ApplicationPolicy

  def index?
    ['admin','admin_operator','owner','manager','shop_manager', 'staff'].include?(user.role)
  end

  def show?
    ['admin','admin_operator','owner','manager','shop_manager', 'staff'].include?(user.role)
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def create?
    ['admin','admin_operator','owner','manager','shop_manager', 'staff'].include?(user.role)
  end
  
  def update?
    ['admin','admin_operator','owner','manager','shop_manager', 'staff'].include?(user.role)
  end

  def destroy?
    user.admin_roles?
  end
  
end
