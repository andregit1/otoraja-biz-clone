class Api::Admin::ShopProductsController < Api::ApiController
  def list
    current_shop = session[:default_user_shop]
    @shop_products = policy_scope(ShopProduct.kept).select('shop_products.*, sc2.purchase_unit_price, stocks.quantity,  IFNULL(fap2.average_price, sc2.average_price) as average_price, stocks.quantity / shop_products.stock_minimum as stock_ratio').joins(%|
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

  def product_categories
    @product_categories = ProductCategory.all
  end

  def product_sort
    @product_sort = ShopProduct.sorts
  end

  def admin_products
    if params[:product_category_id].present?
      @admin_products = AdminProduct.where(product_category: params[:product_category_id])
    end
  end

  def update
    shop_products = params[:shop_products]
    shop_id = params[:shop_id]
    product_category_id = params[:product_category_id]
    begin
      # RDB更新
      ActiveRecord::Base.transaction do
        products = []
        shop_products.each do |key, product|
          product = product.permit(
            :id,
            :product_no,
            :shop_id,
            :product_category_id,
            :admin_product_id,
            :shop_alias_name,
            :item_detail,
            :stock_minimum,
            :sales_unit_price,
            :remind_interval_day,
            :is_stock_control,
            :is_use
          )
          products << ShopProduct.new(product) if product[:shop_alias_name].present?
        end
        
        ShopProduct.import! products, on_duplicate_key_update: [:product_no, :shop_id, :product_category_id, :admin_product_id, :shop_alias_name, :item_detail, :stock_minimum, :sales_unit_price, :remind_interval_day, :is_stock_control, :is_use]
      end

      # 全文検索更新
      ShopProduct.es_import(
        shop_id
      )

      @msg = 'success'
    rescue => e
      @msg = e.message
    end
  end

  def create
    @add_item = []
    begin
      # RDB更新
      ActiveRecord::Base.transaction do
        @add_item = ShopProduct.create(
          shop_id: params[:shop_id],
          product_category_id: params[:product_category_id],
          admin_product_id: params[:admin_product_id] == 0 ? nil : params[:admin_product_id],
          product_no: params[:product_no].empty? ? nil : params[:product_no],
          shop_alias_name: params[:shop_alias_name],
          item_detail: params[:item_detail],
          stock_minimum: params[:stock_minimum],
          sales_unit_price: params[:sales_unit_price],
          remind_interval_day: params[:remind_interval_day],
          is_stock_control: params[:is_stock_control],
          is_use: params[:is_use]
        )

        #ShopProduct.import @add_item
      end
      # 更新
      ShopProduct.es_import_by_id(@add_item.id)
      @msg = @add_item
    rescue => e
      @msg = e.message
    end
  end

  def update_product
    begin
      shop_product = ShopProduct.find_by(id: params[:shop_product_id])

      shop_product.product_category_id = params[:edit_product_category_id]
      shop_product.admin_product_id = params[:admin_product_id]
      shop_product.product_no = params[:product_no]
      shop_product.shop_alias_name = params[:shop_alias_name]
      shop_product.item_detail = params[:item_detail]
      shop_product.stock_minimum = params[:stock_minimum]
      shop_product.sales_unit_price = params[:sales_unit_price]
      shop_product.remind_interval_day = params[:remind_interval_day]
      shop_product.is_use = params[:is_use]
      shop_product.is_stock_control = params[:is_stock_control]

      if shop_product.save
        ShopProduct.es_import_by_id(params[:shop_product_id])
      end

      @msg = shop_product
    rescue => e
      @msg = e.message
    end
  end

  def soft_delete
    current_shop_id = session[:default_user_shop]

    if params[:selected_product]
      shop_products = policy_scope(ShopProduct).where(id: params[:selected_product])
    elsif params[:unselected_product]
      shop_products = policy_scope(ShopProduct).where.not(id: params[:unselected_product])
    else
      shop_products = policy_scope(ShopProduct).where(shop_id: params[:shop_id])
    end

    shop_products_temps = shop_products
    shop_products_temps.to_json

    if params[:product_category_id].present?
      shop_products = shop_products.where(product_category_id: params[:product_category_id])
    end

    if params[:search].present?
      search_words = params[:search].split
      search_words.each do |search|
        shop_products = shop_products.where('shop_products.shop_alias_name LIKE ? or shop_products.item_detail LIKE ?', "%#{search}%", "%#{search}%")
      end
    end
    
    if params[:is_use].present?
      is_use = params[:is_use].to_sym == :yes
      shop_products = shop_products.where(is_use: is_use)
    end

    begin
      ActiveRecord::Base.transaction do
        shop_products.update_all(deleted_at: Time.current, is_use: false)
      end
    rescue => e
      logger.error(e.message)
    end

    shop_products_temps.each do |product|
      begin
        ShopProduct.es_import_by_id(product.id)
      rescue => e
        logger.error(e)
      end
    end

  end  
  
  def check_progress_deleted
    @deleted_product = policy_scope(ShopProduct).where(shop_id: session[:default_user_shop]).discarded
    respond_to do |format|
      format.json {render :json => {deleted_product: @deleted_product.count('id')}}
    end
  end

  def stock_controls
    start_datetime = params[:start_date].present? ? DateTime.parse(params[:start_date]).in_time_zone('UTC') : Otoraja::DateUtils.parse_date_tz(DateTime.now.to_s).beginning_of_day-7.days
    end_datetime = params[:end_date].present? ? DateTime.parse(params[:end_date]).in_time_zone('UTC') : Otoraja::DateUtils.parse_end_date_tz(DateTime.now.to_s).end_of_day-1.days
    if params[:shop_product_id].present?
      @stock_controls = StockControl.get_product_history(params[:shop_product_id], start_datetime, end_datetime)
    end
  end

  def variants
    if params[:product_category_id].present?
      @variants = Variant.where(product_category: params[:product_category_id])
    else
      @variants = Variant.all
    end
  end

  def tech_specs
    if params[:product_category_id].present?
      @tech_specs = TechSpec.where(product_category: params[:product_category_id])
    else
      @tech_specs = TechSpec.all
    end
  end

end