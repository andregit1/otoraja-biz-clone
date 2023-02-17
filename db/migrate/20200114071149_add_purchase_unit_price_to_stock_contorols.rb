class AddPurchaseUnitPriceToStockContorols < ActiveRecord::Migration[5.2]
  def change
    add_column :stock_controls, :purchase_price, :bigint, :after => 'quantity'
    add_column :stock_controls, :purchase_unit_price, :bigint, :after => 'quantity'
  end
end
