class ShopProductCollection
  include ActiveModel::Model
  attr_accessor :shop_products, :shop_id, :stock_controls, :shop_products_ids, :stocks

  def initialize(shop_products = {})
    return if shop_products.blank?

    @shop_products = shop_products
    @shop_id = shop_products.first[:shop_id]
    @stock_controls = Array.new
    @shop_products_ids = Array.new
    @stocks = Array.new
  end

  def save
    ActiveRecord::Base.transaction do
      shop_products.each do |shop_product|  
        quantity = shop_product["stock_attributes"]["quantity"].to_f || 0
        purchase_unit_price = shop_product["stock_controls_attributes"]["purchase_unit_price"].to_i || 0
        purchase_price = (purchase_unit_price * quantity) || 0

        shop_product = ShopProduct.new(shop_product.except(:stock_controls_attributes, :stock_attributes))
        shop_product.save(validate: false)
        
        shop_products_ids << shop_product.id

        stocks << { shop_product_id: shop_product.id, quantity: quantity}

        next unless shop_product.is_stock_control?

        stock_controls << {
          shop_invoice_id: shop_invoice.id,
          shop_product_id: shop_product.id,
          date: Date.today,
          reason: StockControl.stock_actions[:Arrival],
          quantity: quantity,
          difference: quantity,
          stock_at_close: 0, # onboarding so 0
          purchase_unit_price: purchase_unit_price,
          purchase_price: purchase_price,
          average_price: purchase_unit_price
        }
      end
    end

    Stock.import! stocks if stocks.present?
    StockControl.import! stock_controls if stock_controls.present?
    ShopProduct.es_import_by_id(shop_products_ids)

    true
  rescue => e
    errors.add(:error, e)
    Rails.logger.error(e)
    false
  end

  private 

  def shop_invoice
    @shop_invoice ||= ShopInvoice.create(
      shop_id: shop_id,
      invoice_no: 'Bulk Import',
      arrival_date: DateTime.now,
      is_inventory: true,
      status: :closed,
    )
  end
end
