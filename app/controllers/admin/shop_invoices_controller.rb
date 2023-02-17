class Admin::ShopInvoicesController < Admin::ApplicationAdminController
  def index
    @suppliers = Supplier.where(shop_id: session[:default_user_shop])
    @mode = params[:mode].to_i
    @is_invoice = @mode == ShopPurchase.modes[:invoice]
    @is_inventory = @mode == ShopPurchase.modes[:inventory]
  end
end
