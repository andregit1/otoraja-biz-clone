class UpdateTableMaintenanceLogAndMigrationDownPayment < ActiveRecord::Migration[5.2]
  def change
    ActiveRecord::Base.transaction do 
      MaintenanceLog.all.find_all{|m| 
        if m.down_payment_amount.present?
          m.cash_flow_histories.new(
            cash_amount: m.down_payment_amount,
            cash_paid_date: DateTime.current,
            cash_in_out: "IN",
            cash_type: "DOWN_PAYMENT",
            sent_wa_receipt: false
          ).save!
        end
      }
    end

    remove_column :maintenance_logs, :down_payment_amount
  end
end
