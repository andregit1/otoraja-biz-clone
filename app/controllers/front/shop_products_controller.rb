class Front::ShopProductsController < Front::ApiController
  protect_from_forgery :except => [:create]

  def suggest
    shop_id = params[:shop_id] || current_user&.shops&.first&.id
    if shop_id.blank?
      response_bad_request
      return
    end
    @shop_products = []
    if params[:search_word].present? && params[:search_word].length >= 3
      @shop_products = ShopProduct.es_search(
        params[:search_word],
        shop_id,
      ).page(params[:page] || 1).per(10).records
    end
  end

  def quicksearch
    shop_id = params[:shop_id] || current_user&.shops&.first&.id
    @shop_search_tags = ShopSearchTag.own_shop(shop_id).is_using().is_not_empty()
  end

  def history
    shop_id = params[:shop_id] || current_user&.shops&.first&.id
    from_datetime = 1.week.ago
    if params[:search_scope].present?
      case params[:search_scope]
      when '1w' then
        from_datetime = 1.week.ago
      when '1m' then
        from_datetime = 1.month.ago
      when '3m' then
        from_datetime = 3.month.ago
      else
        from_datetime = 1.week.ago
      end
    end
    products = policy_scope(ShopProduct.kept).joins({:maintenance_log_details => {:maintenance_log => :checkin}}).where('checkins.datetime > ?', from_datetime)
    customer = policy_scope(Customer).find(params[:customer_id]) if params[:customer_id].present?
    products = products.where('checkins.customer_id': customer.id) if customer.present?
    if params[:search_word].present? && params[:search_word].length >= 3
      es_result = ShopProduct.es_search(
        params[:search_word],
        shop_id,
      ).per(100).records
      products = products.where(id: es_result.ids)
    end
    @shop_products = products.order('checkins.datetime desc').page(params[:page] || 1).per(10)
    render 'suggest'
  end

  def list
    @customize_shop_product_lists = policy_scope(CustomizeShopProductList).all.order(order: :asc)
  end

  def categories
    @product_categories = ProductCategory.joins(:product_class).where(product_classes: {name: ['PARTS', 'SERVICE', 'NON-SPAREPART']}).order('product_classes.id', 'product_categories.id')
  end

  def create
    new_shop_product_params = shop_product_params
    category_params = new_shop_product_params.delete('product_category')
    @shop_product = ShopProduct.new(new_shop_product_params)

    @shop_product.shop = current_user.shops.first

    product_category = if category_params.present?
      ProductCategory.find(category_params[:id])
    else
      ProductCategory.find_by(name: 'TANPA KATEGORI')
    end
    @shop_product.product_category = product_category unless product_category.nil?

    @shop_product.save!
    ShopProduct.es_import_by_id(
      @shop_product.id
    )
    render 'find'
  end

  def update_price
    unless params["role"] == "staff"
      @shop_product = ShopProduct.find(params["id"])
      ActiveRecord::Base.transaction do
        @shop_product.sales_unit_price = params["sales_unit_price"]
        @shop_product.save!
      end
      render 'find'
    else
     render json: { message: "Staff Can't update the product price", status: 401 }  
    end
  end

  def except_check_token_action
    ['categories']
  end

private
  def shop_product_params
    params.fetch(:shop_product, {}).permit(
      :shop_alias_name,
      :sales_unit_price,
      :product_no,
      :item_detail,
      :is_stock_control,
      :is_use,
      :stock_minimum,
      product_category: [
        :id
      ]
    )
  end
end