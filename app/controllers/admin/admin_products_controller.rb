class Admin::AdminProductsController < Admin::ApplicationAdminController
  def index
    @shops = current_user.managed_shops.where(id: session[:default_user_shop])
    @select_shop = @shops.first
    @product_categories = ProductCategory.joins(:admin_products).distinct.order(id: :asc)
  end

  private
    def shop_products_params
      params.permit(:shop_id,:product_category_id)
    end
end
  