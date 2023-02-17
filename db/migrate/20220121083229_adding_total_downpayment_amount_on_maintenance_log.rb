class AddingTotalDownpaymentAmountOnMaintenanceLog < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_logs, :total_down_payment_amount, :integer, default: 0

    downpayment = MaintenanceLog
                    .joins("RIGHT JOIN (SELECT
                                cash_flow_histories.cashable_id,
                                sum(cash_flow_histories.cash_amount) AS down_payment_total
                              FROM
                                maintenance_logs
                                LEFT JOIN cash_flow_histories ON cash_flow_histories.cashable_id = maintenance_logs.id
                              WHERE 
                                cash_flow_histories.id is not null and cash_flow_histories.cash_amount > 0 AND cash_flow_histories.cash_type = 'DOWN_PAYMENT'
                              GROUP by maintenance_logs.id) AS cash_flow ON cash_flow.cashable_id = maintenance_logs.id")

    downpayment.update_all("maintenance_logs.total_down_payment_amount = down_payment_total")             
  end
end
