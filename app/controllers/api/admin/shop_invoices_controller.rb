class Api::Admin::ShopInvoicesController < Api::ApiController
  def list
    select_supplier = policy_scope(Supplier).find_by(id: params[:supplier_id])
    
    if select_supplier.present?
      @shop_invoices =  policy_scope(ShopInvoice).eager_load(:stock_controls).find_by_mode(params[:mode]).where(shop_id: params[:shop_id]).where(supplier: select_supplier)
    else
      @shop_invoices =  policy_scope(ShopInvoice).eager_load(:stock_controls).find_by_mode(params[:mode]).where(shop_id: params[:shop_id]).includes([:supplier])
    end

    if params[:search].present?
      search_words = params[:search].split
      search_words.each do |search|
        @shop_invoices = @shop_invoices.joins(stock_controls: :shop_product).where('shop_products.shop_alias_name LIKE ? or shop_products.item_detail LIKE ?', "%#{search}%", "%#{search}%").distinct
      end
    end

    if params[:status].present?
      status = ShopInvoice.statuses[params[:status].to_sym]
      @shop_invoices = @shop_invoices.where(status: status)
    end

    order = ShopInvoice.sort_condition[params[:sort]&.to_sym] || 'shop_invoices.updated_at desc'
    @shop_invoices = @shop_invoices.order(order).page(params[:page]).per(10)

    @paginator = view_context.paginate(@shop_invoices)
  end

  def find
    @shop_invoice = policy_scope(ShopInvoice).eager_load(:stock_controls).find_by(id: params[:id])
  end

  def create
    begin
      invoice = params[:data]
      shop = policy_scope(Shop).find_by(id: invoice[:shop_id])
      ActiveRecord::Base.transaction do
        @shop_invoice = ShopInvoice.create!(
          shop_id: shop.id, 
          invoice_no: invoice["invoice_no"],  
          status: invoice["status"].to_i,
          supplier_id: invoice["supplier_id"], 
          arrival_date: invoice["arrival_date"], 
          payment_method: invoice["payment_method"],
          is_inventory: params[:mode].to_i == ShopPurchase.modes[:inventory]
        )
        invoice["stock_controls"].each do |key, stock_control|
          unless invoice["status"].to_i == ShopInvoice.statuses[:open]
            add_stock_and_average_price(stock_control, @shop_invoice)
          else
            StockControl.create(
              date: @shop_invoice.arrival_date,
              shop_product_id: stock_control['shop_product_id'],
              supplier_id: @shop_invoice.supplier_id,
              reason: StockControl.get_reason(params['mode'], stock_control['difference']),
              quantity: stock_control['quantity'],
              purchase_price: stock_control['purchase_price'],
              purchase_unit_price: stock_control['purchase_unit_price'],
              payment_method: stock_control['payment_method'],
              shop_invoice_id: @shop_invoice.id,
              difference: stock_control['difference'].to_i
            )
          end

          if stock_control['is_stock_control'] == 'true'
            shop_product = ShopProduct.find(stock_control['shop_product_id'])
            shop_product.is_stock_control = stock_control['is_stock_control']
            shop_product.save
          end
        end
      end
    rescue ActiveRecord::RecordInvalid => invalid
      logger.debug(invalid.record.errors.to_json)
    rescue => e
      logger.debug(e)
      render json: e.message.to_json
    end
  end

  def update
    @invoice = params[:data]
    begin
      # RDB更新
      ActiveRecord::Base.transaction do
        @shop_invoice = policy_scope(ShopInvoice).find(@invoice["id"])

        ids_exist = []
        @invoice["stock_controls"].each{|k,v| ids_exist << v["id"].to_i}
        ids_deleted = @shop_invoice.stock_controls.map{|m| m.id} - ids_exist

        unless @invoice["stock_controls"].nil?
          handle_stock_control()
        end 
        
        unless ids_deleted.nil?
          handle_delete(ids_deleted)
        end
      end
      @msg = 'success'
    rescue ActiveRecord::RecordInvalid => invalid
      logger.debug(invalid.record.errors.to_json)
    rescue => e
      logger.debug(e)
      @msg = e.message
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      begin
        id = params[:id]
        item = policy_scope(ShopInvoice).find(id)
        item.destroy
      rescue => e
        logger.error(e.message)
      end
    end
  end

  private 

  def handle_stock_control()
    update_shop_invoice
    @invoice["stock_controls"].each do |key, stock_control|
      product = ShopProduct.find(stock_control['shop_product_id'])
      unless stock_control["id"].empty?
        item = StockControl.find(stock_control["id"])
        #stock is saved only when invoice is changed from draft to final so we can just add the new value 
        unless @invoice["status"].to_i == ShopInvoice.statuses[:open]
          add_stock_and_average_price(stock_control, @shop_invoice)
        else
          item.update!(
            shop_invoice_id: @shop_invoice.id,
            date: @invoice["arrival_date"],
            supplier_id: @invoice["supplier_id"],
            quantity: stock_control["quantity"],
            purchase_unit_price: stock_control["purchase_unit_price"],
            purchase_price: stock_control["purchase_price"],
            payment_method: stock_control["payment_method"],
            difference: stock_control["difference"].to_i
          )
        end
      else
        unless @invoice["status"].to_i == ShopInvoice.statuses[:open]
          add_stock_and_average_price(stock_control, @shop_invoice)
        else
          #create_stock_record(stock_control)
          StockControl.create!(
            date: @shop_invoice.arrival_date,
            shop_product_id: stock_control['shop_product_id'],
            supplier_id: @shop_invoice.supplier_id,
            reason: StockControl.get_reason(params['mode'], stock_control['difference']),
            quantity: stock_control['quantity'],
            purchase_price: stock_control['purchase_price'],
            purchase_unit_price: stock_control['purchase_unit_price'],
            payment_method: stock_control['payment_method'],
            shop_invoice_id: @shop_invoice.id,
            difference: stock_control['difference'].to_i
          )
        end
      end
      
      if stock_control['is_stock_control'] == 'true'
        shop_product = ShopProduct.find(stock_control['shop_product_id'])
        shop_product.is_stock_control = stock_control['is_stock_control']
        shop_product.save
      end
    end
  end

  def handle_delete(ids_deleted)
    @shop_invoice.stock_controls.where(id: ids_deleted).destroy_all 
    unless @invoice["stock_controls"].nil?
      update_shop_invoice
    else
      ShopInvoice.delete(@shop_invoice.id)
    end
  end

  def update_shop_invoice()
    @shop_invoice.update!(
      invoice_no: @invoice["invoice_no"],
      shop_id: @invoice["shop_id"],
      supplier_id: @invoice["supplier_id"],
      arrival_date: @invoice["arrival_date"], 
      payment_method: @invoice["payment_method"], 
      status: @invoice["status"].to_i,
    )
  end

  def add_stock_and_average_price(stock_control, shop_invoice )
    #insert or update a stock record
    stock = Stock.find_by(shop_product_id: stock_control['shop_product_id'])
    stock_at_close = stock&.quantity || 0
    if stock.nil?
      #insert new record
      create_stock_record(stock_control)
      stock_control['average_price'] = stock_control['purchase_unit_price']
    else
      #calcualte stock. If record is an inventory type, incoming value is new stock value
      total = shop_invoice.is_inventory? ? stock_control['quantity'] : (stock.quantity + (stock_control['quantity'].to_f))
      stockControlRecord = StockControl.where("shop_product_id = #{stock_control['shop_product_id']} AND average_price IS NOT NULL").last
      
      #guard as there is a chance new record for stock control could have a stock record.
      #if there are not stock control records with an average price defined, use the current value
      if stockControlRecord.nil? || stockControlRecord.average_price.nil? || shop_invoice.is_inventory?
        stock_control['average_price'] =  shop_invoice.is_inventory? ? nil : stock_control['purchase_unit_price']
      else 
        #if the total is positive then calculate the 
        stock_control['average_price'] = get_average_price(stock.quantity, stockControlRecord, total, stock_control['shop_product_id'], stock_control['quantity'], stock_control['purchase_unit_price'])
      end
      stock.update(quantity: total)
    end

    record = StockControl.find_or_initialize_by(id: stock_control['id'])

    record.date = shop_invoice.arrival_date || Date.today
    record.shop_product_id = stock_control['shop_product_id']
    record.supplier_id = shop_invoice.supplier_id
    record.reason = StockControl.get_reason(params['mode'], stock_control['difference'])
    record.quantity =  stock_control['quantity']
    record.purchase_price = stock_control['purchase_price']
    record.purchase_unit_price =  stock_control['purchase_unit_price']
    record.payment_method = stock_control['payment_method']
    record.average_price = stock_control['average_price']
    record.shop_invoice_id = shop_invoice.id
    record.difference = stock_control['difference']
    record.stock_at_close = stock_at_close
    
    #save stock_controls record
    record.save
  end

  def create_stock_record(stock_control)
    #insert new record
    stock = Stock.create(
    shop_product_id: stock_control['shop_product_id'], 
    quantity: stock_control['quantity'])
  end

  def get_average_price(stock_quantity, stockControlRecord, total, shop_product_id, quantity, purchase_unit_price)
    #(stock*prev purchase price || avg)+(newly added stock*purchase price)/new total stock
    averagePrice = FixedAveragePrice.where(shop_product_id: shop_product_id)
    previousPurchaseUnitPrice = stockControlRecord.purchase_unit_price || 0
    @new_avg_price = 0
    unless quantity.present? && purchase_unit_price.present?  
      @new_avg_price
    else
      if averagePrice.empty?
        @new_avg_price = ((stock_quantity*previousPurchaseUnitPrice)+(quantity.to_f*purchase_unit_price.to_f))/total
      else
        @new_avg_price = ((stock_quantity*averagePrice.first().average_price)+(quantity.to_f*purchase_unit_price.to_f))/total
      end
    end
    @new_avg_price
  end
end