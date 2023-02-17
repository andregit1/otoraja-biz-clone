class AddPaymentExpired < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :payment_expired, :datetime, :after => 'payment_date'
  end
end
