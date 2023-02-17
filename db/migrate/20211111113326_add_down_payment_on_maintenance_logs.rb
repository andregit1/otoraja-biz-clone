class AddDownPaymentOnMaintenanceLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_logs, :down_payment_amount, :integer
  end
end
