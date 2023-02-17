class Stock < ApplicationRecord
  belongs_to :shop_product

  def return_stock(item_quantity)
    before_stock_control = self.quantity
    after_stock_control = self.quantity + item_quantity
    self.quantity = after_stock_control
    self.save!
    stock_control = StockControl.new_reason_return
    stock_control.shop_product_id = shop_product.id
    stock_control.quantity = item_quantity
    stock_control.difference = after_stock_control - before_stock_control
    stock_control.stock_at_close = before_stock_control
    stock_control.save!
  end

  def sale_stock(item_quantity)
    before_stock_control = self.quantity
    after_stock_control = self.quantity - item_quantity
    self.quantity = after_stock_control
    self.save!
    stock_control = StockControl.new_reason_sale
    stock_control.shop_product_id = shop_product.id
    stock_control.quantity = item_quantity
    stock_control.difference = after_stock_control - before_stock_control
    stock_control.stock_at_close = before_stock_control
    stock_control.save!
  end

end
