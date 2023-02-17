class DashboardAndSalesIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :checkins, :created_staff_id
    add_index :checkins, :checkout_datetime
    add_index :maintenance_logs, :checkin_id
    add_index :maintenance_logs, :maintained_staff_id
    add_index :maintenance_logs, :updated_staff_id
    add_index :maintenance_log_details, :maintenance_log_id
    add_index :maintenance_log_payment_methods, :maintenance_log_id
    add_index :maintenance_log_payment_methods, :payment_method_id
    add_index :maintenance_log_payment_methods, :created_staff_id
    add_index :shop_staffs, :shop_id
    add_index :maintenance_mechanics, :shop_staff_id
  end
end
