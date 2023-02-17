class Admin::ShopProductsController < Admin::ApplicationAdminController
  def index
    @filter = params["filter"].present? ? params["filter"] : ShopProduct.sorts.keys[0]
    @select_shop = current_user.managed_shops.where(id: session[:default_user_shop]).first
    @product_categories = ProductCategory.all.order(id: :asc)
  end

  def print
    @select_shop = current_user.managed_shops.where(id: session[:default_user_shop]).first
    @product_categories = ProductCategory.all.order(id: :asc)

    @shop_products = policy_scope(ShopProduct).eager_load(:stock).where(shop: shop_products_params[:shop_id])
    if shop_products_params[:product_category_id].present?
      @shop_products = @shop_products.where(product_category_id: shop_products_params[:product_category_id])
    end

    if shop_products_params[:shortage].present?
      @shop_products = @shop_products.where("stocks.quantity < shop_products.stock_minimum")
    end
    
    render :layout => 'admin/print'
  end

  private
    def shop_products_params
      params.permit(:shop_id,:product_category_id,:shortage, :filter)
    end
end
