class Console::StockController < Console::ApplicationConsoleController
  before_action :set_shop, only:[:suppliers]
  def index
    @shops = current_user.managed_shops
    @select_shop = params[:select_shop].present? ? @shops.find(params[:select_shop]) : @shops.first
    @stock_actions = StockControl.stock_actions
    @suppliers = Supplier.where(shop_id: @select_shop.id).order(id: :asc)
    @categories = ProductCategory.all
    @select_category = params[:select_category].present? ? @categories.find(params[:select_category]) : @categories.first
    @pay_type = StockControl.pay_types
    @shortage = params[:shortage].present?
    #@products = policy_scope(ShopProduct).includes(:stock).where(is_use: true, is_stock_control: true).includes(:admin_product)

    order = params[:sort] || 'admin_product_id desc'
    @q = ShopProduct.where(shop_id: @select_shop.id).where(product_category_id: @select_category.id).order(order).ransack(params[:q])
    @products = @q.result.enable_stock_control

    ajax_action unless params[:ajax_handler].blank?
  end

  def show
    render json: ShopProduct.includes(:stock).where(product_category_id: params[:id])
  end

  def suppliers
    render json: Supplier.own_shop(@shop.id).order(id: :asc)
  end

  def update

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
            #(stock*prev purchase price || avg)+(new stock total*purchase price)/new total stock
            averagePrice = FixedAveragePrice.where(shop_product_id: item['shop_product_id'])
            previousPurchaseUnitPrice = stockControlRecord.purchase_unit_price
            if(averagePrice.count==0)
              item['average_price'] = ((stock.quantity*previousPurchaseUnitPrice)+(item['quantity'].to_f*item['purchase_unit_price'].to_f))/total
            else
              item['average_price'] = ((stock.quantity*averagePrice.first().average_price)+(item['quantity'].to_f*item['purchase_unit_price'].to_f))/total
            end
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
        average_price: item['average_price']
      )
    end

    render json: items

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
    end
  end
  
  private 
  def set_shop()
    @shop = current_user.managed_shops.where(id: params[:id]).first
  end

end
