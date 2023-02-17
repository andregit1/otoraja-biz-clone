class AddIndexToStockAndStockControlAndShopInvoice < ActiveRecord::Migration[5.2]
  def change
    add_index :stocks, :shop_product_id
    add_index :shop_invoices, :shop_id
    add_index :stock_controls, :shop_invoice_id
  end
end
