class ChangeMaintenanceLogDetailsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_log_details, :discount_type, :int, :after => 'discount'
    add_column :maintenance_log_details, :discount_rate, :int, :after => 'discount_type'
    add_column :maintenance_log_details, :discount_amount, :bigint, :after => 'discount_rate', :default => 0
    remove_column :maintenance_log_details, :discount
    remove_column :maintenance_log_details, :wage
    remove_column :maintenance_log_details, :note
  end
end
