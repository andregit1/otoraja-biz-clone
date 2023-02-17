class AddInvoiceNumberToSubscription < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :invoice_number, :string, :limit => 10
  end
end
