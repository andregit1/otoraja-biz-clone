class Admin::ShopPolicy < ApplicationPolicy
  def new_branch?
    user.owner?
  end
end
