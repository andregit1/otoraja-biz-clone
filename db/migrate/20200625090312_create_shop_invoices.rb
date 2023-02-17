class CreateShopInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_invoices do |t|
      t.string :invoice_no, null: false, index: false
      t.references :shop, index: false
      t.references :supplier, index: false, null: true
      t.references :shop_staff, index: false, null: true
      t.datetime :arrival_date, index: false
      t.string :payment_method, index:false
      t.timestamps
    end
  end
end
