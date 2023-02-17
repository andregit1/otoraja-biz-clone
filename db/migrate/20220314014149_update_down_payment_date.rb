class UpdateDownPaymentDate < ActiveRecord::Migration[5.2]
  def change
    CashFlowHistory
      .joins("LEFT JOIN maintenance_logs ON maintenance_logs.id = cash_flow_histories.cashable_id")
      .joins("LEFT JOIN checkins ON checkins.id = maintenance_logs.checkin_id")
      .where('cash_paid_date > checkins.checkout_datetime').update_all("cash_paid_date=checkins.datetime")
  end
end
