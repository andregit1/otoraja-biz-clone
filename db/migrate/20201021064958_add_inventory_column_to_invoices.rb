class AddInventoryColumnToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :shop_invoices, :is_inventory, :boolean, :after => 'status'
  end
end
