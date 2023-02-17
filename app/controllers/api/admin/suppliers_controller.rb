class Api::Admin::SuppliersController < Api::ApiController
  def list
    @suppliers = policy_scope(Supplier).where(shop_id: params[:shop_id])
  end
end
