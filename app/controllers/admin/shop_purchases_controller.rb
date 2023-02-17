class Admin::ShopPurchasesController < Admin::ApplicationAdminController
  def index
    @mode = params['mode'].to_i
    @is_invoice = @mode == ShopPurchase.modes[:invoice]
    @is_inventory = @mode == ShopPurchase.modes[:inventory]
    @select_shop = current_user.managed_shops.where(id: session[:default_user_shop]).first
    @suppliers = Supplier.where(shop_id: session[:default_user_shop])
  end

  def edit
    begin
      @shop_invoice = policy_scope(ShopInvoice).find(params[:id])
      @stock_controls = @shop_invoice.stock_controls
      @mode = @shop_invoice.is_inventory
      @is_invoice = @shop_invoice.find_inventory_or_invoice.is_invoice
      @is_inventory = @shop_invoice.find_inventory_or_invoice.is_inventory
      @select_shop = current_user.managed_shops.where(id: session[:default_user_shop]).first
      @suppliers = Supplier.where(shop_id: session[:default_user_shop])
      @suppliers = @suppliers.with_discarded if @shop_invoice.status == "closed"
      @supplier = @shop_invoice.supplier
    rescue => exception
      redirect_to admin_shop_invoices_path, flash: {danger: I18n.t('reject_access')}
    end
  end

  alias_method :show, :edit
end
  