module StockManagementConcern
  extend ActiveSupport::Concern

  included do
    after_save :change_stock_quantity
    after_save :create_stock_control
    after_destroy :destroy_stock_quantity
    after_destroy :create_stock_control
  end

  def change_stock_quantity
    return unless is_stock_control?

    @stock_quantity = self.shop_product.stock_quantity.nil? ? 0 : self.shop_product.stock_quantity

    before_quantity = self.quantity_before_last_save.nil? ? 0 : self.quantity_before_last_save
    @diff = self.quantity.to_f - before_quantity.to_f
    after_stock_quantity = @stock_quantity - @diff

    stock = self.shop_product.stock
    if stock.nil?
      Stock.create(shop_product_id: self.shop_product.id, quantity: after_stock_quantity)
    else
      stock.quantity = after_stock_quantity
      stock.save
    end
  end

  def destroy_stock_quantity
    return unless is_stock_control?

    @stock_quantity = self.shop_product.stock_quantity.nil? ? 0 : self.shop_product.stock_quantity
    @diff = -self.quantity.to_f
    # back stock
    after_stock_quantity = @stock_quantity + self.quantity.to_f

    stock = self.shop_product.stock
    unless stock.nil?
      stock.quantity = after_stock_quantity
      stock.save
    end
  end

  def create_stock_control
    return unless is_stock_control?
    # Do not record if there is no inventory variation.
    return if @diff == 0
    ActiveRecord::Base.transaction do
      begin
        StockControl.create!(
          shop_product_id: self.shop_product_id,
          date: Date.today,
          reason:  -@diff < 0 ? StockControl.stock_actions[:Sale] : StockControl.stock_actions[:Return],
          quantity: self.quantity,
          difference: -@diff,
          stock_at_close: @stock_quantity
        )
      rescue ActiveRecord::RecordInvalid => invalid
        logger.error(invalid.message)
      end
    end
  end

private
  def is_stock_control?
    self.shop_product.present? && self.shop_product.is_stock_control
  end
end
