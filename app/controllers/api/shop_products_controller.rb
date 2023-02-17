class Api::ShopProductsController < Api::ApiController
  def suggest
    shop_id = params[:shop_id] || current_user&.shops&.first&.id
    if shop_id.blank?
      response_bad_request
      return
    end
    @shop_products = []
    product_category_id = nil
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
    @shop_search_tags
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
    products = policy_scope(ShopProduct).joins({:maintenance_log_details => {:maintenance_log => :checkin}}).where('checkins.datetime > ?', from_datetime)
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

  def list_detail
    @customize_shop_product_list = policy_scope(CustomizeShopProductList).find(params[:id])
    @shop_products = @customize_shop_product_list.customize_shop_product_details.order(order: :asc)
    render 'suggest'
  end

  def create
    new_shop_product_params = shop_product_params
    shop_id = current_user.shops.first.id
    new_shop_product_params[:shop_id] = shop_id

    if new_shop_product_params[:product_category_id].blank?
      product_category = ProductCategory.find_by(name: 'TANPA KATEGORI')
      new_shop_product_params[:product_category_id] = product_category.id unless product_category.nil?
    end

    @shop_product = ShopProduct.new(new_shop_product_params)
    
    begin
      @shop_product.save!
      ShopProduct.es_import_by_id(
        @shop_product.id
      )
      render json: { status: 'success', data: @shop_product }
    rescue => e
      render json: { status: 'error', data: @shop_product.errors }
    end
  end

  private
    def shop_product_params
      params.permit(:shop_alias_name, :product_category_id, :sales_unit_price, :product_no, :item_detail,:is_stock_control, :is_use)
    end
end
