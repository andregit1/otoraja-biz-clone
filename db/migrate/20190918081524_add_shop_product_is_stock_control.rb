class AddShopProductIsStockControl < ActiveRecord::Migration[5.2]
  def change
    add_column :shop_products, :is_stock_control, :boolean, :after => 'remind_interval_day', null:false
  end
end
