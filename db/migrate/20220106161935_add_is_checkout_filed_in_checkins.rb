class AddIsCheckoutFiledInCheckins < ActiveRecord::Migration[5.2]
  def change
    add_column :checkins, :is_checkout, :boolean, default: false, after: :checkout_datetime
  
    checkout = Checkin
                .joins('INNER JOIN maintenance_logs ON maintenance_logs.checkin_id = checkins.id ')
                .joins('INNER JOIN maintenance_log_payment_methods ON maintenance_logs.id = maintenance_log_payment_methods.maintenance_log_id')
                .where('checkins.checkout_datetime IS NOT NULL AND maintenance_log_payment_methods.payment_method_id IS NOT NULL') 
    checkout.update_all(is_checkout: true)
  end
end
