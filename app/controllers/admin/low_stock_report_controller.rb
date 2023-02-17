class Admin::LowStockReportController < Admin::ApplicationAdminController
  def index
    shop_id = session[:default_user_shop]
    @select_category = params[:select_category]
    @sort = {
      "A - Z": "shop_products.shop_alias_name ASC", 
      "Z - A": "shop_products.shop_alias_name DESC",
      "Stok Tertinggi": "stocks.quantity DESC",
      "Stok Terendah": "stocks.quantity ASC"
    }
    @select_sort = params[:sort] || "shop_products.shop_alias_name ASC"

    @product_list = ShopProduct.kept.select('shop_products.*, stocks.quantity').joins(:stock).where(shop_id: shop_id).where(is_stock_control: true)
      .where('stocks.quantity <= shop_products.stock_minimum').order(@select_sort).page(params[:page]).per(10).order(id: :asc).distinct

    if @select_category.present?
      @product_list = @product_list.where(product_category_id: @select_category)
    end
  end
end
