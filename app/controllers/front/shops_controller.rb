class Front::ShopsController < Front::ApiController
  def info
    if params[:shop_id].present?
      @shop = current_user.shops.where("shops.id = ?", params[:shop_id]).first
    else
      @shop = current_user.shops.first
    end
  end

  def transaction_summary
    shop_id = current_user.shops.first.id
    start_datetime = Otoraja::DateUtils.parse_date_tz(params[:start_date])
    end_datetime = Otoraja::DateUtils.parse_end_date_tz(params[:end_date])

    @transaction_summary = MaintenanceLogDetail.transaction_summary(shop_id, start_datetime, end_datetime)
  end 

  def transaction_most_sales
    shop_id = current_user.shops.first.id
    start_datetime = Otoraja::DateUtils.parse_date_tz(params[:start_date])
    end_datetime = Otoraja::DateUtils.parse_end_date_tz(params[:end_date])

    @sales_details_by_product = MaintenanceLogDetail.aggregate_sales_details_by_product(shop_id, start_datetime, end_datetime).take(5)
  end 

  def mechanic_summary
    shop_id = current_user.shops.first.id
    start_datetime = Otoraja::DateUtils.parse_date_tz(params[:start_date])
    end_datetime = Otoraja::DateUtils.parse_end_date_tz(params[:end_date])

    @sales_by_mechanic = ShopStaff.aggregate_mechanic_sales_recap(shop_id, start_datetime, end_datetime)
    @mechanic_transactions = ShopStaff.aggregate_mechanic_transactions(shop_id, start_datetime, end_datetime)
    @mechanic_summary = []
    @sales_by_mechanic.each_with_index do |mechanic, index|
      @mechanic_summary << {mechanic: mechanic[:mechanic], total_sales: mechanic[:total], total_transactions: @mechanic_transactions[index][:transactions]}
    end
  end

  def low_stock
    shop_id = current_user.shops.first.id
    product_list = ShopProduct.kept.select('shop_products.*, stocks.quantity').joins(:stock).where(shop_id: shop_id).where(is_stock_control: true)
      .where('stocks.quantity <= shop_products.stock_minimum').order('stocks.quantity ASC')

    if params[:product_categories_id].present?
      product_list = product_list.where(product_category_id: params[:product_categories_id])
    end

    if params[:zero_stock] == "true"
      @product_list = product_list
    else
      @product_list = product_list.where('stocks.quantity > 0')
    end
  end
end
