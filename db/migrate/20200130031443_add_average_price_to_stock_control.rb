class AddAveragePriceToStockControl < ActiveRecord::Migration[5.2]
  def change
    add_column :stock_controls, :average_price, :bigint, :after => 'purchase_price'
  end
end
