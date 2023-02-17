class Console::ShopProductsController < Console::ApplicationConsoleController
  def index
    @filter = params["filter"].present? ? params["filter"] : ShopProduct.sorts.keys[0]
    @shops = current_user.managed_shops
    @product_categories = ProductCategory.all.order(id: :asc)
  end

  def print
    @shops = current_user.managed_shops
    @select_shop = @shops.first
    @product_categories = ProductCategory.all.order(id: :asc)

    @shop_products = policy_scope(ShopProduct).eager_load(:stock).where(shop: shop_products_params[:shop_id])
    if shop_products_params[:product_category_id].present?
      @shop_products = @shop_products.where(product_category_id: shop_products_params[:product_category_id])
    end

    if shop_products_params[:shortage].present?
      @shop_products = @shop_products.where("stocks.quantity < shop_products.stock_minimum")
    end
    
    render :layout => 'console/print'
  end

  def import
    @shop_product_upload = ShopProductUpload.new
  end

  def import_confirm
    @shop_product_upload = ShopProductUpload.new(shop_product_upload_params)
    if @shop_product_upload.valid?
      @shop_products = @shop_product_upload.get_shop_products
      @shop_products_with_error = @shop_product_upload.get_shop_products_with_error
      @shop = Shop.find_by_id(@shop_product_upload.get_shop_id)
      @shop_product_collection = ShopProductCollection.new
    else
      render :import
      # redirect_to console_shop_products_import_path, flash: { danger: @shop_product_upload.errors.full_messages }
    end
  end

  def import_execution
    @shop_products = shop_product_collection_params[:shop_products].values
    @shop_product_collection = ShopProductCollection.new(@shop_products)

    if @shop_product_collection.save
      render json: {message: t("admin.customer.import_success"), success: true}
    else
      render json: {message:  @shop_product_collection.errors.details[:error].first.values.join(" *** "), success: false}
    end
  end

  def template_export
    @admin_products = AdminProduct.eager_load(product_category: :product_class).order(id: :asc)
    respond_to do |format|
      format.csv {
        send_data render_to_string, filename: "bulk_import_template_#{Time.zone.now.strftime('%Y%m%d')}.csv"
      }
    end
  end
  
  def list
    current_shop = params[:shop_id]
    @shop_products = ShopProduct.kept.select('shop_products.*, sc2.purchase_unit_price, stocks.quantity,  IFNULL(fap2.average_price, sc2.average_price) as average_price, stocks.quantity / shop_products.stock_minimum as stock_ratio').joins(%|
      LEFT JOIN (
        SELECT sc.*
        FROM stock_controls as sc
        WHERE sc.id = (
        SELECT sc2.id
        FROM stock_controls as sc2
        WHERE sc.shop_product_id = sc2.shop_product_id
        AND sc2.purchase_unit_price IS NOT NULL
        ORDER BY sc2.created_at DESC
        LIMIT 1
        )
      ) as sc2
      on shop_products.id = sc2.shop_product_id
    |).joins(%|
      LEFT JOIN (
        SELECT fap.*
        FROM fixed_average_prices as fap
        WHERE fap.id = (
        SELECT fap2.id
        FROM fixed_average_prices as fap2
        WHERE fap.shop_product_id = fap2.shop_product_id
        AND fap2.`average_price` IS NOT NULL
        ORDER BY fap2.created_at DESC
        LIMIT 1
        )
      ) as fap2
      on shop_products.id = fap2.shop_product_id
    |).left_joins(:stock).left_joins(:admin_product).where(shop_id: current_shop)
    
    if params[:product_category_id].present?
      @shop_products = @shop_products.where(product_category_id: params[:product_category_id])
    end

    if params[:search].present?
      search_words = params[:search].split
      search_words.each do |search|
        @shop_products = @shop_products.where('admin_products.name LIKE ? or shop_products.shop_alias_name LIKE ? or shop_products.item_detail LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
      end
    end

    if params[:is_use].present?
      is_use = params[:is_use].to_sym == :yes
      @shop_products = @shop_products.where(is_use: is_use)
    end
    order = ShopProduct.sort_condition[params[:sort]&.to_sym] || 'updated_at desc'
    @shop_products = @shop_products.order(order)
    @shop_products = @shop_products.page(params[:page]).per(10)
    @paginator = view_context.paginate(@shop_products)
  end  

  private
    def shop_products_params
      params.permit(:shop_id,:product_category_id,:shortage)
    end

    def shop_product_upload_params
      params.fetch(:shop_product_upload, {}).permit(:file, :shop_id)
    end

    def shop_product_collection_params
      params.permit(
        shop_products: [
          :shop_id,
          :product_no,
          :product_category_id,
          :admin_product_id,
          :shop_alias_name,
          :item_detail,
          :stock_minimum,
          :sales_unit_price,
          :remind_interval_day,
          :is_stock_control,
          :is_use,
          stock_attributes: [
            :quantity
          ],
          stock_controls_attributes: [
            :purchase_unit_price
          ]
        ]
      )
    end
end
