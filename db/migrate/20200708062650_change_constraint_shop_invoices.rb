class ChangeConstraintShopInvoices < ActiveRecord::Migration[5.2]
  def change
    change_column :shop_invoices, :invoice_no, :string, null: :true
  end
end
