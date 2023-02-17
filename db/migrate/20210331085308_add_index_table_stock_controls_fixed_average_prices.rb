class AddIndexTableStockControlsFixedAveragePrices < ActiveRecord::Migration[5.2]
  def change
    add_index :stock_controls, :shop_product_id
    add_index :fixed_average_prices, :shop_product_id
  end
end
