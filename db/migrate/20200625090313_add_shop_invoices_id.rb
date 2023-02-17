class AddShopInvoicesId < ActiveRecord::Migration[5.2]
  def change
    add_column :stock_controls, :shop_invoice_id, :bigint, :after => 'shop_product_id'
  end
end
