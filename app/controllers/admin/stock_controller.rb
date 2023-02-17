class Admin::StockController < Admin::ApplicationAdminController
  before_action :set_shop, only:[:suppliers, :update]
  def index
    @shops = current_user.managed_shops
    @select_shop = params[:select_shop].present? ? @shops.find(params[:select_shop]) : @shops.first
    @stock_actions = StockControl.stock_actions
    @suppliers = Supplier.where(shop_id: @select_shop.id).order(id: :asc)
    @categories = ProductCategory.all
    @select_category = params[:select_category].present? ? @categories.find(params[:select_category]) : @categories.first
    @pay_type = StockControl.pay_types
    @shortage = params[:shortage].present?
    order = params[:sort] || 'admin_product_id desc'
    @q = ShopProduct.order(order).ransack(params[:q])
    @products =  policy_scope(ShopProduct).select('shop_products.*, sc2.purchase_unit_price, sc2.id as stock_control_id', 'sc2.updated_at as stock_control_updated_at', 'mld2.created_at as maintenance_log_created_at')
    .left_joins(:stock).joins(%|
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
    |)
    .left_joins(:stock).joins(%|
      LEFT JOIN (
        SELECT mld.*
        FROM maintenance_log_details as mld
        WHERE mld.id = (
        SELECT mld2.id
        FROM maintenance_log_details as mld2
        WHERE mld.shop_product_id = mld2.shop_product_id
        ORDER BY mld2.id DESC
        LIMIT 1
        )
      ) as mld2
      on shop_products.id = mld2.shop_product_id
    |)
    .left_joins(:stock).left_joins(:admin_product).where(shop: @select_shop, is_use: true, is_stock_control: true)
    ajax_action unless params[:ajax_handler].blank?
  end

  def show
    render json: ShopProduct.includes(:stock).where(product_category_id: params[:id])
  end

  def suppliers
    render json: Supplier.own_shop(@shop.id).order(id: :asc)
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        items = []
        for item in JSON.parse(params[:data]) do
          #insert or update a stock record
          if item['id'].blank?
            #insert new record
            stock = Stock.create(shop_product_id: item['shop_product_id'], quantity: item['quantity'])
            item['average_price'] = item['purchase_unit_price']
            items << stock
          else
            stock = Stock.find(item['id'])

            next if stock.nil?
            
            isArrival = item['reason'].to_i==StockControl.stock_actions[:Arrival]

            #calcualte and save stock record by 'reason' 
            total = isArrival ? stock.quantity + (item['quantity'].to_f) : stock.quantity - (item['quantity'].to_f)

            stockControlRecord = StockControl.where(shop_product_id: item['shop_product_id'], reason: StockControl.stock_actions[:Arrival]).last()

            #if the previously entered record was not given a purchasing price then 
            #we will not be able to calculate the average price.
            if stockControlRecord.average_price.nil?
              item['average_price'] = item['purchase_unit_price']
            else
              
            #if the total is positive then calculate the average
            if isArrival
              item['average_price'] = get_average_price(stock.quantity, stockControlRecord, total, item['shop_product_id'], item['quantity'], item['purchase_unit_price'])
            else
              item['purchase_unit_price'] = stockControlRecord.purchase_unit_price
              item['purchase_price'] = stockControlRecord.purchase_price
              item['average_price'] = stockControlRecord.average_price
            end
          end

          stock.update(quantity: total)

          items << stock

          end
          #save stock_controls record
          #values are not needed in UI 

          StockControl.create(
            date: item['date'],
            shop_product_id: item['shop_product_id'],
            supplier_id: item['supplier_id'],
            reason: item['reason'],
            quantity: item['quantity'],
            purchase_price: item['purchase_price'],
            purchase_unit_price: item['purchase_unit_price'],
            payment_method: item['payment_method'],
            average_price: item['average_price'],
          )
        end
        render json: items
      end
    rescue => e
      render json: e.message.to_json
    end
  end

  def edit
    data = JSON.parse(params[:data])
    stockControlRecord = StockControl.find(data['id'])
    previousStockControlRecord = StockControl.where(shop_product_id: data['shop_product_id']).order('id DESC').offset(1).last
    unless stockControlRecord.nil?
      stockControlRecord.purchase_price = data['purchase_price']
      stockControlRecord.purchase_unit_price = data['purchase_unit_price']
      if previousStockControlRecord.nil? || previousStockControlRecord.average_price.nil?
        stockControlRecord.average_price = data['purchase_unit_price']
      else
        stock = Stock.where(shop_product_id: data['shop_product_id']).first
        #stock before newly added control record
        #so we can recalculate the average price
        stock_quantity = stock.quantity - stockControlRecord.quantity
        stockControlRecord.average_price = get_average_price(stock_quantity, previousStockControlRecord, stock.quantity, stockControlRecord.shop_product_id, stockControlRecord.quantity, data['purchase_unit_price'])
      end
      stockControlRecord.save()
    end
  end

  def stock_controll
    stockControlRecord = StockControl.where(shop_product_id: params[:id]).last()
    maintenantsLogDetailRecord = MaintenanceLogDetail.where(shop_product_id: stockControlRecord.shop_product_id).last();
    if maintenantsLogDetailRecord.nil? || 
      (stockControlRecord.quantity && stockControlRecord.purchase_price.nil?) || 
      maintenantsLogDetailRecord.created_at <= stockControlRecord.updated_at

      render json: stockControlRecord
    else
      render json: nil?
    end
  end

  def ajax_action
    if params[:ajax_handler] == 'handle_stock_history'
      # Ajaxの処理
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

      data = StockHistory.where(date: [start_date..end_date], shop_product_id: params[:shop_product_id]).map{|stock| [stock.date.strftime('%d/%m/%Y'), stock.quantity]}.to_h
      labels = (start_date..end_date).map{|date| [date.strftime('%d/%m/%Y'), 0]}.to_h
      @chart_data = labels.merge(data)
      @shop_product = ShopProduct.find(params[:shop_product_id])

      unless @chart_data.empty?
        render
      else
        render json: 'no data'
      end
    elsif params[:ajax_handler] == 'handle_daily_history'
      # Ajaxの処理
      date = Date.parse(params[:daily_history_date])
      shop_id = params[:daily_history_shop_id]

      @stock_controls = StockControl.joins(:shop_product).where(shop_products: {shop_id: shop_id}, date: date).order(id: 'desc')

      render
    elsif params[:ajax_handler] == 'handle_stock_profit'
      data = StockControl.select('stock_controls.*, shop_products.sales_unit_price').joins(:shop_product).where(stock_controls: {id: params[:stock_control_id]}, shop_products: {id: params[:stock_product_id]}).first
      unless data.nil?
        stock_cogs_hash = {}
        stock_cogs_hash[data.created_at.strftime('%d/%m/%Y')] = data.average_price
        sup = data.sales_unit_price || 0
        ap = data.average_price || 0
        stock_profit_hash = {}
        stock_profit_hash[data.created_at.strftime('%d/%m/%Y')] = sup - ap
        @stock_cogs = stock_cogs_hash
        @stock_profit = stock_profit_hash
      end
    end
  end
  
  private 

  def get_average_price(stock_quantity, stockControlRecord, total, shop_product_id, quantity, purchase_unit_price)
    #(stock*prev purchase price || avg)+(newly added stock*purchase price)/new total stock
    averagePrice = FixedAveragePrice.where(shop_product_id: shop_product_id)
    previousPurchaseUnitPrice = stockControlRecord.purchase_unit_price

    unless quantity.present? && purchase_unit_price.present?  
      return 0
    else
      if(averagePrice.count==0)
        ((stock_quantity*previousPurchaseUnitPrice)+(quantity.to_f*purchase_unit_price.to_f))/total
      else
        ((stock_quantity*averagePrice.first().average_price)+(quantity.to_f*purchase_unit_price.to_f))/total
      end
    end
  end

  def set_shop()
    @shop = current_user.managed_shops.where(id: params[:id]).first
  end

end
