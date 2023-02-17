class AddStatusToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :shop_invoices, :status, :integer, :after => 'payment_method' 
  end
end
