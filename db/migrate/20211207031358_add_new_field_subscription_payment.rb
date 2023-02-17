class AddNewFieldSubscriptionPayment < ActiveRecord::Migration[5.2]
  def change
    add_reference :subscriptions, :payment_type, index: true
    add_column :subscriptions, :qr_path, :string
    add_column :subscriptions, :payment_gateway_expired, :datetime
    add_column :subscriptions, :payment_gateway_va, :string
    add_column :subscriptions, :payment_transaction_id, :integer
  end
end
